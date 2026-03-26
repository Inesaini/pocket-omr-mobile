import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/background_scaffold.dart';
import '../../profile/model/user_model.dart';
import '../../profile/pages/profile_page.dart';
import '../../profile/widgets/profile_avatar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});


  static final _dummyUser = UserModel(
    firstName: 'Mohamed',
    lastName:  'Amine',
    userName:  'Mohamed Amine',
    email:     'Mohamedamine@esi-sba.dz',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  );

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(user: _dummyUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: AppAssets.profileBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                Image.asset(
                  AppAssets.quizorLogo,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),

             
                GestureDetector(
                  onTap: () => _goToProfile(context),
                  child: ProfileAvatar(
                    networkUrl: _dummyUser.avatarUrl,
                    radius: 24,
                  ),
                ),
              ],
            ),
          ),

         
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}