import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../widgets/segmentation_failure_dialog.dart';
import 'exam_service.dart';

String _basename(String path) => path.split(RegExp(r'[\\/]')).last;

/// Uploads the given files, showing a blocking progress dialog. Returns the
/// updated [Exam] on success, or null if it failed (a snackbar is shown).
///
/// If the backend reports sheets it couldn't segment, a popup lists them. When
/// the upload was a set of individual image files (e.g. camera captures), the
/// popup offers "Retry" which re-uploads ONLY the failed sheets.
Future<Exam?> uploadSheetsWithProgress(
  BuildContext context,
  String examId,
  List<String> filePaths,
  ExamService service,
) async {
  if (filePaths.isEmpty) return null;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  Exam exam;
  try {
    exam = await service.uploadSheets(examId, filePaths);
    if (context.mounted) Navigator.of(context).pop(); // close progress
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop(); // close progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
    return null;
  }

  if (exam.failedSheets.isNotEmpty && context.mounted) {
    // Retry is only meaningful when we can re-send the failed sheets on their
    // own — i.e. the originals were individual image files, not a single zip.
    final failedNames = exam.failedSheets.map((f) => _basename(f.filename)).toSet();
    final retryPaths =
        filePaths.where((p) => failedNames.contains(_basename(p))).toList();

    final retry = await showSegmentationFailureDialog(
      context,
      exam.failedSheets,
      allowRetry: retryPaths.isNotEmpty,
    );

    if (retry && retryPaths.isNotEmpty && context.mounted) {
      final retried = await uploadSheetsWithProgress(
        context,
        examId,
        retryPaths,
        service,
      );
      return retried ?? exam;
    }
  }

  return exam;
}

/// Lets the user pick a .zip of scanned sheets, uploads it, and on success
/// pushes the screen built by [onResult] with the updated exam.
Future<void> pickZipAndUpload(
  BuildContext context,
  Exam exam,
  ExamService service,
  Widget Function(Exam updated) onResult,
) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['zip'],
  );
  final path = result?.files.single.path;
  if (path == null) return;
  if (!context.mounted) return;

  final updated = await uploadSheetsWithProgress(context, exam.id, [path], service);
  if (updated != null && context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => onResult(updated)),
    );
  }
}
