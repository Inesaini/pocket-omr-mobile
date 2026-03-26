import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/background_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';
import '../model/user_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field.dart';



class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _userNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;

 
  File? _localImage;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user.firstName);
    _lastNameCtrl  = TextEditingController(text: widget.user.lastName);
    _userNameCtrl  = TextEditingController(text: widget.user.userName);
    _emailCtrl     = TextEditingController(text: widget.user.email);
    _passwordCtrl  = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _userNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
           
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.primary),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primary),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (source == null) return; 

    final picked = await ImagePicker().pickImage(
      source:       source,
      imageQuality: 85,
      maxWidth:     800,
    );

    if (picked != null) {
      setState(() => _localImage = File(picked.path));
    }
  }

  void _saveChanges() {
    final updated = widget.user.copyWith(
      firstName: _firstNameCtrl.text.trim(),
      lastName:  _lastNameCtrl.text.trim(),
      userName:  _userNameCtrl.text.trim(),
      email:     _emailCtrl.text.trim(),
     
    );

    debugPrint('Saving: ${updated.toJson()}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: AppAssets.editProfileBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.labelText),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          
            ProfileAvatar(
              networkUrl:    _localImage == null
                  ? widget.user.avatarUrl
                  : null,
              localFile:     _localImage,
              showEditBadge: true,
              onEditTap:     _pickImage,
            ),
            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ProfileField(
                      label:      'First Name',
                      readOnly:   false,
                      controller: _firstNameCtrl),
                  ProfileField(
                      label:      'Last Name',
                      readOnly:   false,
                      controller: _lastNameCtrl),
                  ProfileField(
                      label:      'UserName',
                      readOnly:   false,
                      controller: _userNameCtrl),
                  ProfileField(
                      label:      'Email',
                      readOnly:   false,
                      controller: _emailCtrl),
                  ProfileField(
                      label:      'Password',
                      readOnly:   false,
                      isPassword: true,
                      controller: _passwordCtrl),
                  const SizedBox(height: 8),

                 
                  PrimaryButton(
                    label:     'Save changes',
                    onPressed: _saveChanges,
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