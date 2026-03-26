import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';


class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.networkUrl,
    this.localFile,
    this.radius = 55,
    this.showEditBadge = false,
    this.onEditTap,
  });

  final String?       networkUrl;
  final File?         localFile;
  final double        radius;
  final bool          showEditBadge;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final ImageProvider image = localFile != null
     ? FileImage(localFile!)
     : (networkUrl != null
        ? NetworkImage(networkUrl!) as ImageProvider
        : AssetImage(AppAssets.avatarPlaceholder)); 

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.avatarBorder,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: image,
          ),
        ),
        if (showEditBadge)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}