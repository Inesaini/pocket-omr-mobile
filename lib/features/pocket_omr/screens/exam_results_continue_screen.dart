import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../services/exam_service.dart';
import '../services/upload_flow.dart';
import '../theme/pocket_colors.dart';
import '../widgets/exam_results_body.dart';
import '../widgets/gradient_scaffold.dart';
import 'camera_screen.dart';
import 'exam_results_stop_screen.dart';

class ExamResultsContinueScreen extends StatelessWidget {
  final Exam exam;
  const ExamResultsContinueScreen({super.key, required this.exam});

  void _continue(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Continue correction',
                  style: TextStyle(
                    color: PocketColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 18),
                _SheetOption(
                  icon: Icons.folder_zip_outlined,
                  label: 'Upload ZIP',
                  onTap: () {
                    Navigator.pop(ctx);
                    pickZipAndUpload(
                      context,
                      exam,
                      ExamService(),
                      (updated) => ExamResultsStopScreen(exam: updated),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _SheetOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraScreen(exam: exam),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: ExamResultsBody(
        exam: exam,
        bottomAction: SizedBox(
          width: 260,
          height: 52,
          child: ElevatedButton(
            onPressed: () => _continue(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: PocketColors.lightBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Continue the correction',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PocketColors.lightBlue),
        ),
        child: Row(
          children: [
            Icon(icon, color: PocketColors.navy),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: PocketColors.navy,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
