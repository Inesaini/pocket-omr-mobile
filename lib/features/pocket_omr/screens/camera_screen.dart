import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/exam.dart';
import '../services/exam_service.dart';
import '../services/upload_flow.dart';
import '../theme/pocket_colors.dart';
import 'exam_results_stop_screen.dart';

class CameraScreen extends StatefulWidget {
  final Exam exam;
  const CameraScreen({super.key, required this.exam});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  String? _error;
  bool _permissionDenied = false;

  final List<XFile> _captured = [];
  final _service = ExamService();
  bool _busy = false;

  final int _target = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _bootstrap();
      if (mounted) setState(() {});
    }
  }

  Future<void> _bootstrap() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _permissionDenied = true;
          _error = 'Camera permission denied';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = 'No camera found on this device');
        return;
      }

      final back = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _error = null;
      });
    } on CameraException catch (e) {
      setState(() => _error = 'Camera error: ${e.code}');
    } catch (e) {
      setState(() => _error = 'Failed to start camera: $e');
    }
  }

  Future<void> _shutter() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      setState(() => _captured.add(file));
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: ${e.code}')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _previewLast() async {
    if (_captured.isEmpty) return;
    final last = _captured.last;
    final delete = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _PhotoPreviewScreen(file: File(last.path)),
      ),
    );
    if (delete == true && mounted) {
      _captured.remove(last);
      unawaitedDelete(last.path);
      setState(() {});
    }
  }

  void unawaitedDelete(String path) {
    try {
      final f = File(path);
      if (f.existsSync()) f.deleteSync();
    } catch (_) {}
  }

  Future<void> _finishAndUpload() async {
    if (_captured.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExamResultsStopScreen(exam: widget.exam),
        ),
      );
      return;
    }
    final updated = await uploadSheetsWithProgress(
      context,
      widget.exam.id,
      _captured.map((x) => x.path).toList(),
      _service,
    );
    if (updated != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ExamResultsStopScreen(exam: updated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildViewfinder()),
            if (_controller?.value.isInitialized ?? false)
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _RuleOfThirdsPainter()),
                ),
              ),
            Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinder() {
    final controller = _controller;

    if (_error != null) {
      return _MessageView(
        icon: _permissionDenied
            ? Icons.no_photography_outlined
            : Icons.error_outline,
        title: _permissionDenied ? 'Camera access needed' : 'Camera error',
        message: _error!,
        action: _permissionDenied
            ? TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('Open settings'),
              )
            : TextButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _bootstrap();
                  });
                },
                child: const Text('Retry'),
              ),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return const _MessageView(
        icon: Icons.camera_alt_outlined,
        title: 'Starting camera…',
        message: '',
        action: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? 1,
            height: controller.value.previewSize?.width ?? 1,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final count = _captured.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(gradient: PocketColors.background),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: PocketColors.navy),
          ),
          Expanded(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: PocketColors.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(text: '$count '),
                      const TextSpan(
                        text: '/',
                        style: TextStyle(color: PocketColors.lightBlue),
                      ),
                      TextSpan(text: ' $_target'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                _SegmentedProgress(
                  segments: 10,
                  filled: (10 * count / _target).round(),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _busy ? null : _finishAndUpload,
            style: TextButton.styleFrom(
              foregroundColor: PocketColors.navy,
              side: const BorderSide(color: PocketColors.navy),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text(
              'upload &\ncorrect',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final thumbnail = _captured.isNotEmpty ? _captured.last : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(gradient: PocketColors.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _previewLast,
            child: Container(
              width: 58,
              height: 58,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PocketColors.lightBlue, width: 1.5),
                color: Colors.white,
              ),
              child: thumbnail != null
                  ? Image.file(
                      File(thumbnail.path),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.photo_outlined,
                      color: PocketColors.navy,
                      size: 26,
                    ),
            ),
          ),
          GestureDetector(
            onTap: _shutter,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PocketColors.lightBlue, width: 2),
              ),
              child: _busy
                  ? const Padding(
                      padding: EdgeInsets.all(22),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: PocketColors.navy,
                      ),
                    )
                  : const Icon(
                      Icons.camera,
                      size: 44,
                      color: PocketColors.navy,
                    ),
            ),
          ),
          GestureDetector(
            onTap: _shutter,
            child: Container(
              width: 70,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: PocketColors.lightBlue),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: PocketColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget action;

  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222222),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 16),
          action,
        ],
      ),
    );
  }
}

class _RuleOfThirdsPainter extends CustomPainter {
  const _RuleOfThirdsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    for (var i = 1; i < 3; i++) {
      final dx = w * i / 3;
      canvas.drawLine(Offset(dx, 0), Offset(dx, h), paint);
      final dy = h * i / 3;
      canvas.drawLine(Offset(0, dy), Offset(w, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RuleOfThirdsPainter oldDelegate) => false;
}

class _PhotoPreviewScreen extends StatelessWidget {
  final File file;
  const _PhotoPreviewScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Text('Preview'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                child: Center(
                  child: Image.file(file, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Keep',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final yes = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete photo?'),
                          content: const Text(
                            'This will remove the photo from the correction queue.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (yes == true && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedProgress extends StatelessWidget {
  final int segments;
  final int filled;
  const _SegmentedProgress({required this.segments, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(segments, (i) {
        return Container(
          width: 16,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: i < filled
                ? PocketColors.navy
                : PocketColors.navy.withOpacity(0.2),
          ),
        );
      }),
    );
  }
}
