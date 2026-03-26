import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/background_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';
import '../model/user_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field.dart';
import 'edit_profile_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.user});

  final UserModel? user;

  static final _dummyUser = UserModel(
    firstName: 'Mohamed',
    lastName:  'Amine',
    userName:  'Mohamed Amine',
    email:     'Mohamedamine@esi-sba.dz',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  );

  @override
  Widget build(BuildContext context) {
    final currentUser = user ?? _dummyUser;

    return BackgroundScaffold(
      backgroundAsset: AppAssets.profileBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.labelText),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            ProfileAvatar(networkUrl: currentUser.avatarUrl),
            const SizedBox(height: 12),
            Text(currentUser.fullName, style: AppTextStyles.userName),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(user: currentUser),
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.buttonDark,
                side: const BorderSide(color: AppColors.buttonDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
                elevation: 4,
                shadowColor: AppColors.buttonDark.withOpacity(0.25),
              ),
              child: const Text('Edit your profil'),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ProfileField(label: 'First Name', value: currentUser.firstName),
                  ProfileField(label: 'Last Name',  value: currentUser.lastName),
                  ProfileField(label: 'UserName',   value: currentUser.userName),
                  ProfileField(label: 'Email',      value: currentUser.email),
                  const ProfileField(
                    label: 'Password',
                    value: '********************',
                    isPassword: true,
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Log Out',
                    onPressed: () {
                      
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}