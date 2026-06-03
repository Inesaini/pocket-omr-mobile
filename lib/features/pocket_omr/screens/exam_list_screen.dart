import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../services/exam_service.dart';
import '../services/upload_flow.dart';
import '../theme/pocket_colors.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/screen_title.dart';
import '../widgets/search_field.dart';
import 'camera_screen.dart';
import 'exam_results_stop_screen.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  final _service = ExamService();
  String _query = '';
  late Future<List<Exam>> _future = _service.fetchExamsToCorrect();

  void _search(String q) {
    setState(() {
      _query = q;
      _future = _service.fetchExamsToCorrect(query: q);
    });
  }

  void _openCamera(Exam exam) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CameraScreen(exam: exam)),
    );
  }

  void _openUpload(Exam exam) {
    pickZipAndUpload(
      context,
      exam,
      _service,
      (updated) => ExamResultsStopScreen(exam: updated),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const ScreenTitle('Exam list to correct'),
            const SizedBox(height: 18),
            SearchField(onChanged: _search),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<Exam>>(
                future: _future,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final exams = snap.data!;
                  if (exams.isEmpty) {
                    return Center(
                      child: Text(
                        _query.isEmpty
                            ? 'No exams to correct'
                            : 'No results for "$_query"',
                        style: const TextStyle(color: PocketColors.muted),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: exams.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ExamRow(
                      exam: exams[i],
                      onScan: () => _openCamera(exams[i]),
                      onUpload: () => _openUpload(exams[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamRow extends StatelessWidget {
  final Exam exam;
  final VoidCallback onScan;
  final VoidCallback onUpload;

  const _ExamRow({
    required this.exam,
    required this.onScan,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PocketColors.navy.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              exam.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: PocketColors.navy,
              ),
            ),
          ),
          IconButton(
            onPressed: onScan,
            icon: const Icon(
              Icons.center_focus_strong_outlined,
              color: PocketColors.navy,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            decoration: BoxDecoration(
              color: PocketColors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: onUpload,
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
