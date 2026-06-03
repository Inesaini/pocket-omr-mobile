import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_divider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/logo_widget.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const double _hPadding = 24;
  static const double _buttonHPadding = 32;
  static const double _headerHeight = 280;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'\d'))) {
      return 'Password must contain at least one digit';
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleSignup() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _showError('Please fill all fields');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }
    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      _showError(passwordError);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      // Auth state is now authenticated; pop the auth routes so the root
      // _AuthGate's MainShell (with the bottom nav) becomes visible.
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Registration failed'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/sign_up.png',
              fit: BoxFit.cover,
            ),
          ),
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: _headerHeight,
                      width: double.infinity,
                      child: const SafeArea(
                        bottom: false,
                        child: Center(child: LogoWidget()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: _hPadding),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'First Name',
                            controller: _firstNameController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hintText: 'Last Name',
                            controller: _lastNameController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hintText: 'Password',
                            isPassword: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: _buttonHPadding - _hPadding),
                            child: Consumer<AuthProvider>(
                              builder: (context, auth, child) {
                                if (auth.status == AuthStatus.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                }
                                return CustomButton(
                                  text: 'Sign up',
                                  backgroundColor: Colors.white,
                                  textColor: AppColors.deepBlue,
                                  hasGlow: true,
                                  onPressed: _handleSignup,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: _hPadding),
                      child: Column(
                        children: [
                          const CustomDivider(),
                          const SizedBox(height: 14),
                          const Text(
                            'Already have an account ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.deepBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
