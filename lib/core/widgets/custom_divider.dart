import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ligne gauche
        const Expanded(
          child: Divider(
            color: Colors.white, // La ligne blanche
            thickness: 1, // Épaisseur de la ligne
            height: 1,
          ),
        ),
        
        // Le cercle au milieu (dawira)
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 10), // Espace entre la ligne et le cercle
          decoration: const BoxDecoration(
            color: Color(0xFF003E75), // Le bleu foncé exact
            shape: BoxShape.circle,
          ),
        ),
        
        // Ligne droite
        const Expanded(
          child: Divider(
            color: Colors.white, // La ligne blanche
            thickness: 1, // Épaisseur de la ligne
            height: 1,
          ),
        ),
      ],
    );
  }
}