import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../pocket_omr/theme/pocket_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const _GradientShell(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return _GradientShell(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (Navigator.canPop(context))
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.labelText,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              )
            else
              const SizedBox(height: 16),
            const ProfileAvatar(),
            const SizedBox(height: 12),
            Text(user.fullName, style: AppTextStyles.userName),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.buttonDark,
                side: const BorderSide(color: AppColors.buttonDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                elevation: 4,
                shadowColor: AppColors.buttonDark.withValues(alpha: 0.25),
              ),
              child: const Text('Edit your profile'),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ProfileField(label: 'First Name', value: user.firstName),
                  ProfileField(label: 'Last Name', value: user.lastName),
                  ProfileField(label: 'Email', value: user.email),
                  ProfileField(label: 'Role', value: user.role),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Log Out',
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _GradientShell extends StatelessWidget {
  final Widget child;
  const _GradientShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8F4FD),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PocketColors.background),
        child: SafeArea(child: child),
      ),
    );
  }
}
