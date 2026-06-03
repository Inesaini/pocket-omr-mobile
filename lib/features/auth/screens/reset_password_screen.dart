import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── PNG Background layer ──────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/forgot_password.png',
              fit: BoxFit.cover,
            ),
          ),

          // ── Foreground content ────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.deepBlue),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Reset Your\nPassword',
                                  style: TextStyle(
                                    color: AppColors.deepBlue,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Enter the verification code sent\nto your email to reset your\npassword.",
                                  style: TextStyle(
                                    color: AppColors.deepBlue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _AvatarCard(),
                        ],
                      ),

                      const SizedBox(height: 50),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New password',
                          style: TextStyle(
                            color: AppColors.deepBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CustomTextField(
                        hintText: 'Enter your new password',
                        isPassword: true,
                        withBorder: true,
                      ),

                      const SizedBox(height: 24),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm password',
                          style: TextStyle(
                            color: AppColors.deepBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CustomTextField(
                        hintText: 'Confirm your new password',
                        isPassword: true,
                        withBorder: true,
                      ),

                      const SizedBox(height: 48),

                      CustomButton(
                        text: 'Confirm',
                        backgroundColor: AppColors.deepBlue,
                        textColor: Colors.white,
                        borderRadius: 14.0,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    ),
                    child: const Text(
                      'Back to login ?',
                      style: TextStyle(
                        color: AppColors.deepBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
        border: Border.all(color: AppColors.deepBlue, width: 3.5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Icon(Icons.person, color: AppColors.deepBlue, size: 65),
          ),
          Positioned(
            bottom: 12,
            left: 6,
            right: 6,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'xxxx',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
