import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../theme/pocket_colors.dart';
import '../widgets/exam_results_body.dart';
import '../widgets/gradient_scaffold.dart';

class ExamResultsStopScreen extends StatelessWidget {
  final Exam exam;
  const ExamResultsStopScreen({super.key, required this.exam});

  void _stop(BuildContext context) {
    // Returns to ExamList by popping all screens pushed since the list.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: ExamResultsBody(
        exam: exam,
        bottomAction: SizedBox(
          width: 180,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _stop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: PocketColors.stopRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Stop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
