import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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
                      SkipText(
                        text: 'Skip',
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
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InterestsScreen();
                        },
                      ),
                    );
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
  const ProfileCard({super.key, required this.onSelected});
  final Function(String img) onSelected;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: null,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset('assets/images/m1.png', fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () => {onSelected('')},
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.constTheme,
                shape: BoxShape.circle,
                border: BoxBorder.all(color: MyColors.constWhite, width: 2),
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
