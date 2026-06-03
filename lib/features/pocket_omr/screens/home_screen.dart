import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../profile/pages/profile_page.dart';
import '../models/exam.dart';
import '../services/exam_service.dart';
import '../theme/pocket_colors.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/ring_progress.dart';
import '../widgets/screen_title.dart';
import 'exam_results_continue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ExamService();
  late Future<List<Exam>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchRecentActivities();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final profName = (user?.firstName.isNotEmpty == true)
        ? 'Prof. ${user!.firstName}'
        : 'Prof. Amrani';

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _WelcomeCard(
              name: profName,
              onAvatarTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            const SizedBox(height: 22),
            const ScreenTitle('Your recent activities'),
            const SizedBox(height: 14),
            Expanded(
              child: FutureBuilder<List<Exam>>(
                future: _future,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final exams = snap.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: exams.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _RecentExamCard(exam: exams[i]),
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

class _WelcomeCard extends StatelessWidget {
  final String name;
  final VoidCallback onAvatarTap;
  const _WelcomeCard({required this.name, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PocketColors.lightBlue, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: PocketColors.navy,
                  height: 1.25,
                ),
                children: [
                  const TextSpan(
                    text: 'W',
                    style: TextStyle(color: PocketColors.lightBlue),
                  ),
                  const TextSpan(text: 'elcome back,\n'),
                  TextSpan(
                    text: '$name. ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: 'Ready to grade today',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: PocketColors.lightBlue, width: 2),
                color: const Color(0xFFF5E4D3),
              ),
              child: const Icon(
                Icons.person,
                size: 44,
                color: PocketColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentExamCard extends StatelessWidget {
  final Exam exam;
  const _RecentExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExamResultsContinueScreen(exam: exam),
          ),
        );
      },
      child: Container(
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
            RingProgress(
              progress: exam.totalStudents == 0
                  ? 0
                  : exam.correctedCount / exam.totalStudents,
              color: PocketColors.lightBlue,
              child: Text(
                '${exam.correctedCount}/${exam.totalStudents}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PocketColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 12),
            RingProgress(
              progress: exam.avgConfidence / 100,
              color: const Color(0xFF8BE0B8),
              child: Text(
                '${exam.avgConfidence.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PocketColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
