import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../services/exam_service.dart';
import '../theme/pocket_colors.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/screen_title.dart';
import '../widgets/search_field.dart';
import 'exam_results_continue_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _service = ExamService();
  late Future<List<HistoryExam>> _future = _service.fetchHistory();

  void _search(String q) {
    setState(() => _future = _service.fetchHistory(query: q));
  }

  void _openDetails(HistoryExam h) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final exam = await _service.fetchExamDetails(h.id);
      if (!mounted) return;
      Navigator.of(context).pop(); // close progress
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExamResultsContinueScreen(exam: exam),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // close progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load exam: $e')),
      );
    }
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
            const ScreenTitle('History'),
            const SizedBox(height: 18),
            SearchField(onChanged: _search),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<HistoryExam>>(
                future: _future,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snap.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _HistoryCard(
                      item: items[i],
                      onTap: () => _openDetails(items[i]),
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

class _HistoryCard extends StatelessWidget {
  final HistoryExam item;
  final VoidCallback onTap;
  const _HistoryCard({required this.item, required this.onTap});

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final confColor = PocketColors.confidenceColor(item.avgConfidence);
    const processedColor = PocketColors.lightBlue;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PocketColors.lightBlue, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: PocketColors.lightBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '${item.pages} pages  ${_formatDate(item.date)}',
                        style: const TextStyle(
                          color: PocketColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: PocketColors.navy),
                  ),
                  child: Text(
                    'Avg : ${item.avgScore.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: PocketColors.navy,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _StatLine(
              label: 'Photos processed',
              value: '${item.processedPages}/${item.totalPages}',
              ratio: item.processedRatio,
              color: processedColor,
            ),
            const SizedBox(height: 8),
            _StatLine(
              label: 'Avg confidence',
              value: '${item.avgConfidence.toStringAsFixed(0)}%',
              ratio: item.avgConfidence / 100,
              color: confColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  final double ratio;
  final Color color;

  const _StatLine({
    required this.label,
    required this.value,
    required this.ratio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: PocketColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
