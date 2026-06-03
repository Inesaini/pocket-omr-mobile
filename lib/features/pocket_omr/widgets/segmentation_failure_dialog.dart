import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/exam.dart';

/// Shows a popup listing scanned sheets the backend couldn't read
/// (segmentation failures). Returns `true` if the user tapped "Retry".
///
/// Pass [onRetry] only when individual sheets can be re-sent (e.g. the camera
/// flow). For ZIP uploads omit it — a full re-upload would duplicate the
/// sheets that already succeeded — and only a "Got it" button is shown.
Future<bool> showSegmentationFailureDialog(
  BuildContext context,
  List<FailedSheet> failed, {
  bool allowRetry = false,
}) async {
  if (failed.isEmpty) return false;

  final count = failed.length;
  final retried = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 1
                  ? "1 sheet couldn't be read"
                  : "$count sheets couldn't be read",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepBlue,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'These pages were skipped — they were not graded. '
            'Re-scan them with the whole sheet in frame and good lighting.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final f in failed)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2, right: 8),
                            child: Icon(Icons.insert_drive_file_outlined,
                                size: 18, color: Colors.redAccent),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: f.filename,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(text: '  —  ${f.reason}'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (allowRetry)
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Skip'),
          ),
        if (allowRetry)
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Retry'),
          )
        else
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Got it'),
          ),
      ],
    ),
  );
  return retried ?? false;
}
