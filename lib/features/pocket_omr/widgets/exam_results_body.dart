import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../theme/pocket_colors.dart';
import 'confidence_bar.dart';

class ExamResultsBody extends StatelessWidget {
  final Exam exam;
  final Widget bottomAction;

  const ExamResultsBody({
    super.key,
    required this.exam,
    required this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  color: PocketColors.navy,
                  size: 28,
                ),
              ),
            ],
          ),
          const _Title('Exam results overview'),
          const SizedBox(height: 14),
          _InfoCard(exam: exam),
          const SizedBox(height: 22),
          const _ColumnHeaders(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: exam.students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _StudentRow(student: exam.students[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: bottomAction),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    final first = text[0];
    final rest = text.substring(1);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: PocketColors.navy,
          height: 1.1,
        ),
        children: [
          TextSpan(
            text: first,
            style: const TextStyle(color: PocketColors.lightBlue),
          ),
          TextSpan(text: rest),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Exam exam;
  const _InfoCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PocketColors.lightBlue, width: 1.3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Exam title',
                  child: Text(
                    exam.title.split(' ').first,
                    style: const TextStyle(
                      color: PocketColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Student total',
                  child: Text(
                    '${exam.totalStudents}',
                    style: const TextStyle(
                      color: PocketColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Progress',
                  child: Row(
                    children: [
                      Text(
                        '${exam.correctedCount}/${exam.totalStudents}',
                        style: const TextStyle(
                          color: PocketColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SegProgress(
                          ratio: exam.totalStudents == 0
                              ? 0
                              : exam.correctedCount / exam.totalStudents,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Student rest',
                  child: Text(
                    '${exam.remaining}',
                    style: const TextStyle(
                      color: PocketColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Average grade',
                  child: Text(
                    exam.gradedStudents.isEmpty
                        ? '—'
                        : '${exam.totalPoints}/${exam.totalMaxPoints}'
                            '  (${exam.avgGradePercent.toStringAsFixed(0)}%)',
                    style: TextStyle(
                      color: PocketColors.scoreColor(exam.avgGradePercent / 100),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Avg confidence',
                  child: exam.gradedStudents.isEmpty
                      ? const Text(
                          '—',
                          style: TextStyle(
                            color: PocketColors.navy,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : ConfidenceBar(percent: exam.avgConfidence, width: 70),
                ),
              ),
            ],
          ),
          if (exam.reviewCount > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${exam.reviewCount} '
                  '${exam.reviewCount == 1 ? "student needs" : "students need"} review',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PocketColors.navy,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: PocketColors.navy),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _SegProgress extends StatelessWidget {
  final double ratio;
  const _SegProgress({required this.ratio});

  @override
  Widget build(BuildContext context) {
    // Guard against NaN/Infinity (e.g. 0/0) which would crash .round().
    final safe = ratio.isFinite ? ratio.clamp(0.0, 1.0) : 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(8, (i) {
        final filled = i < (8 * safe).round();
        return Container(
          width: 6,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: filled ? PocketColors.navy : PocketColors.navy.withOpacity(
              0.25,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class _ColumnHeaders extends StatelessWidget {
  const _ColumnHeaders();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: PocketColors.lightBlue,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(flex: 3, child: Text('Student', style: style)),
          Expanded(flex: 2, child: Text('Score', style: style)),
          Expanded(flex: 2, child: Text('Confident', style: style)),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final StudentResult student;
  const _StudentRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final scoreColor = PocketColors.scoreColor(student.scoreRatio);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: student.needsReview ? const Color(0xFFFFF6E9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: student.needsReview
              ? Colors.orange
              : PocketColors.navy.withOpacity(0.6),
          width: student.needsReview ? 1.4 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: PocketColors.lightBlue, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: PocketColors.lightBlue.withOpacity(0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              student.initials,
              style: const TextStyle(
                color: PocketColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        student.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PocketColors.navy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (student.needsReview) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.flag, color: Colors.orange, size: 16),
                    ],
                  ],
                ),
                if (student.needsReview)
                  Text(
                    student.flaggedQuestions.isEmpty
                        ? 'Needs review'
                        : 'Review Q${student.flaggedQuestions.join(', Q')}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'ID :${student.studentId}',
                    style: const TextStyle(
                      color: PocketColors.muted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${student.score}/${student.maxScore}',
              style: TextStyle(
                color: scoreColor,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ConfidenceBar(percent: student.confidence),
          ),
        ],
      ),
    );
  }
}
