import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    dobController.dispose();
    profileController.dispose();
    bioController.dispose();
    genderController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    Permission permission;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.photos.isLimited) {
        permission = Permission.photos;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }

    final status = await permission.request();

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(updateProfileNotifierProvider);

    ref.listen(updateProfileNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Profile Updated.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              await PrefsHelper.saveUserProfile(
                bio: user.data?.bio,
                dateOfBirth: user.data?.dateOfBirth,
                fullName: user.data?.fullName,
                gender: user.data?.gender,
                profession: user.data?.profession,
                profilePhotoUrl: user.data?.profilePhotoUrl,
              );
              await PrefsHelper.saveStatus(
                isLoggedIn: true,
                isProfileUpdated: true,
                isPrefUpdated: false,
              );
              // ✅ Navigate only after snackbar disappears
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InterestsScreen();
                  },
                ),
                (Route<dynamic> route) => false,
              );
            });
          }
        },
        error: (err, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MyBoldText(
                text: '$err',
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkipText(
                        text: '',
                        backEnable: false,
                        onClick: () {},
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      MyBoldText(
                        text: 'Profile Details',
                        color: MyColors.textColor(context),
                        fontSize: 24,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          spacing: 10,
                          children: [
                            ProfileCard(
                              selectedImage: _selectedImage,
                              // networkImageUrl: userProfile?.profilePhotoUrl,
                              onSelected: _pickImage,
                            ),

                            const SizedBox(height: 20),
                            MyInputField(
                              controller: nameController,
                              hintText: 'Full Name',
                              condition: (text) => text.isNotEmpty,
                            ),
                            EndIconInputField(
                              controller: dobController,
                              hintText: 'Select DOB',
                              onRead: true,
                              onEndIconClick: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                                return picked != null
                                    ? '${picked.year}-${picked.month}-${picked.day}'
                                    : '';
                              },
                            ),
                            MyDropdown(
                              hint: 'Select Gender',
                              options: genders,
                              onSelected: (selected) {
                                genderController.text = selected;
                              },
                            ),
                            MyInputField(
                              controller: professionController,
                              hintText: 'Profession',
                              condition: (text) => text.isNotEmpty,
                            ),
                            MyInputField(
                              controller: bioController,
                              hintText: 'Bio',
                              maxLine: 3,
                              condition: (text) => text.isNotEmpty,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: MyButton(
                  text: 'Continue',
                  isLoading: authState.isLoading,
                  onClick: () async {
                    String? userId = await PrefsHelper.getUserId();
                    if (_selectedImage != null && userId != null) {
                      await ref
                          .read(updateProfileNotifierProvider.notifier)
                          .updateProfile(
                            userId: userId,
                            fullName: nameController.text,
                            profession: professionController.text,
                            dateOfBirth: dobController.text,
                            gender: genderController.text,
                            bio: bioController.text,
                            profilePhotoFile: _selectedImage,
                          );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.selectedImage,
    this.networkImageUrl,
    required this.onSelected,
  });

  final File? selectedImage;
  final String? networkImageUrl;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            clipBehavior: Clip.antiAlias,
            child: (selectedImage != null && selectedImage!.path.isNotEmpty)
                ? Image.file(selectedImage!, fit: BoxFit.cover)
                : (networkImageUrl?.isNotEmpty == true
                      ? Image.network(networkImageUrl!, fit: BoxFit.cover)
                      : Image.asset('assets/images/m2.jpg', fit: BoxFit.cover)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: onSelected,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.constTheme,
                shape: BoxShape.circle,
                border: Border.all(color: MyColors.constWhite, width: 2),
              ),
              child: Icon(Icons.camera_alt, color: MyColors.constWhite),
            ),
          ),
        ),
      ],
    );
  }
}

class SkipText extends StatelessWidget {
  const SkipText({
    super.key,
    this.backEnable = false,
    required this.text,
    required this.onClick,
    required this.onBackClick,
  });
  final bool backEnable;
  final String text;
  final VoidCallback onClick;
  final VoidCallback onBackClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (backEnable)
          InkWell(
            onTap: () => onBackClick(),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: BoxBorder.all(color: MyColors.borderColor(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: MyColors.constTheme,
                ),
              ),
            ),
          ),
        if (!backEnable) SizedBox.shrink(),
        InkWell(
          onTap: () => onClick(),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: MyBoldText(text: text, color: MyColors.constTheme),
          ),
        ),
      ],
    );
  }
}
