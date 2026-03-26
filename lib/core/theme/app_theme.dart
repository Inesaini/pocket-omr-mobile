import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  static const primary      = Color(0xFF1B4F8A);
  static const buttonDark   = Color(0xFF1B3D6E);
  static const avatarBorder = Color(0xFF2A6BB5);
  static const fieldBorder  = Color(0xFF2A6BB5);
  static const labelText    = Color(0xFF1B3D6E);
  static const hintText     = Color(0xFF555555);
}


class AppTextStyles {
  AppTextStyles._();

  static const userName = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const fieldLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.labelText,
  );

  static const fieldValue = TextStyle(
    fontSize: 15,
    color: AppColors.hintText,
  );
}


class AppAssets {
  AppAssets._();

  static const profileBackground     = 'assets/images/profile_back.png';
  static const editProfileBackground = 'assets/images/edit_profile_back.png';
  static const avatarPlaceholder     = 'assets/images/placeholder.png';
  static const quizorLogo            = 'assets/images/quizor_logo.png';
}