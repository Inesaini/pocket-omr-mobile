import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/background_scaffold.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/pages/profile_page.dart';
import '../../profile/widgets/profile_avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final greetingName = user?.firstName.isNotEmpty == true
        ? user!.firstName
        : 'there';

    return BackgroundScaffold(
      backgroundAsset: AppAssets.profileBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppAssets.quizorLogo,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                GestureDetector(
                  onTap: () => _goToProfile(context),
                  child: const ProfileAvatar(radius: 24),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome, $greetingName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelText,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
