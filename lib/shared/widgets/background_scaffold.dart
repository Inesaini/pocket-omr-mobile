import 'package:flutter/material.dart';


class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    super.key,
    required this.body,
    required this.backgroundAsset,
  });

  final Widget body;
  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
      
          Image.asset(
            backgroundAsset,
            fit: BoxFit.fill,
          ),

          
          SafeArea(child: body),
        ],
      ),
    );
  }
}