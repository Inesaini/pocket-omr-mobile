import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import 'login_screen.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                                  'Forgot\npassword',
                                  style: TextStyle(
                                    color: AppColors.deepBlue,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Don't worry we got you",
                                  style: TextStyle(
                                    color: AppColors.deepBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _AvatarCard(),
                        ],
                      ),

                      const SizedBox(height: 60),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.deepBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CustomTextField(
                        hintText: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        withBorder: true,
                      ),

                      const SizedBox(height: 40),

                      CustomButton(
                        text: 'Send the code',
                        backgroundColor: AppColors.deepBlue,
                        textColor: Colors.white,
                        borderRadius: 14.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VerifyCodeScreen()),
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
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
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
      width: 130,
      height: 130,
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
            top: 15,
            left: 0,
            right: 0,
            child: Icon(Icons.person, color: AppColors.deepBlue, size: 70),
          ),
          Positioned(
            bottom: 15,
            left: 8,
            right: 8,
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'xxxx',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
