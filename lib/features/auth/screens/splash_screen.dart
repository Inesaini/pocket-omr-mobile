import 'package:flutter/material.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../../core/widgets/custom_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const double _hPadding = 24;
  static const double _buttonHPadding = 32;
  static const Color _deepBlue = Color(0xFF0D3B6E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const LogoWidget(),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _hPadding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Smart platform for creating\nand evaluating quizzes.',
                      style: TextStyle(
                        color: _deepBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      _buttonHPadding, 0, _buttonHPadding, 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        text: 'Sign Up',
                        backgroundColor: Colors.white,
                        textColor: _deepBlue,
                        hasGlow: true,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Sign In',
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        borderColor: Colors.white,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                      ),
                    ],
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
