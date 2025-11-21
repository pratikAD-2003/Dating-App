import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/edgecases.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  final List<String> genders = ['Male', 'Female', 'Other'];
  String? profilePhotoUrl;
  String? userId;
  bool _isLoading = true;

  @override
  void initState() {
    _loadProfileData();
    super.initState();
  }

  Future<void> _loadProfileData() async {
    final photo = await PrefsHelper.getProfilePhotoUrl();
    final name = await PrefsHelper.getFullName();
    final bio = await PrefsHelper.getBio();
    final dob = await PrefsHelper.getDateOfBirth();
    final job = await PrefsHelper.getProfession();
    final gender = await PrefsHelper.getGender();
    String? id = await PrefsHelper.getUserId();

    // Update UI if data found locally
    setState(() {
      profilePhotoUrl = photo;
      userId = id;
      nameController.text = name ?? "N/A";
      genderController.text = gender ?? "N/A";
      dobController.text = Utils.isoToSlashDate(dob ?? "");
      professionController.text = job ?? "N/A";
      bioController.text = bio ?? "N/A";
      _isLoading = false;
    });
  }

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
              duration: const Duration(seconds: 2),
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: MyColors.constTheme),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 15,
                              children: [
                                MyBackButton(),
                                MyBoldText(
                                  text: 'Edit Profile',
                                  color: MyColors.textColor(context),
                                  fontSize: 24,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: Column(
                                spacing: 10,
                                children: [
                                  ProfileCard(
                                    networkImageUrl: profilePhotoUrl,
                                    selectedImage: _selectedImage,
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
                                          ? '${picked.day}/${picked.month}/${picked.year}'
                                          : '';
                                    },
                                  ),
                                  MyDropdown(
                                    hint: 'Select Gender',
                                    initialValue: genderController.text,
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
                        text: 'Update',
                        enabled: Edgecases.validateProfileInputs(
                          fullName: nameController.text,
                          profession: professionController.text,
                          dateOfBirth: dobController.text,
                          gender: genderController.text,
                          bio: bioController.text,
                        ),
                        isLoading: authState.isLoading,
                        onClick: () async {
                          if (userId != null) {
                            if (_selectedImage == null) {
                              await ref
                                  .read(updateProfileNotifierProvider.notifier)
                                  .updateProfile(
                                    userId: userId ?? "",
                                    fullName: nameController.text,
                                    profession: professionController.text,
                                    dateOfBirth: dobController.text,
                                    gender: genderController.text,
                                    bio: bioController.text,
                                  );
                            } else {
                              await ref
                                  .read(updateProfileNotifierProvider.notifier)
                                  .updateProfile(
                                    userId: userId ?? "",
                                    fullName: nameController.text,
                                    profession: professionController.text,
                                    dateOfBirth: dobController.text,
                                    gender: genderController.text,
                                    bio: bioController.text,
                                    profilePhotoFile: _selectedImage,
                                  );
                            }
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
