import 'package:flutter/material.dart';

import '../theme/pocket_colors.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const GradientScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration: const BoxDecoration(gradient: PocketColors.background),
        child: SafeArea(child: body),
      ),
    );
  }
}
