import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  @override
  Widget build(BuildContext context) {
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
                            ProfileCard(onSelected: (img) {}),
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
                child: MyButton(text: 'Update', onClick: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
