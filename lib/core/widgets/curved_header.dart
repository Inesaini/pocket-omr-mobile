import 'package:flutter/material.dart';

/// A white panel with a deep circular bottom curve (dawira shape).
class CurvedHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const CurvedHeader({
    super.key,
    required this.child,
    this.height = 340, // increased height to accommodate large logo
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _DeepCircleClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _DeepCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start top-left
    path.lineTo(0, size.height - 100); 
    
    // Create a very deep U-curve (like a half-circle "dawira")
    path.quadraticBezierTo(
      size.width / 2,     // Control point X: middle
      size.height + 60,   // Control point Y: pushed far down to make it deep
      size.width,         // End point X: right edge
      size.height - 100,  // End point Y: matching left edge height
    );
    
    // Go to top-right and close
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
