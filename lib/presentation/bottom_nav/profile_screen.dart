import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/edit/edit_interest.dart';
import 'package:dating_app/presentation/profile/edit/edit_language.dart';
import 'package:dating_app/presentation/profile/edit/edit_preferences.dart';
import 'package:dating_app/presentation/profile/edit/edit_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            MyProfileAppBarSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ProfileDetailSection(),
                    const SizedBox(height: 30),
                    ProfileOptionCardItem(
                      icon: 'assets/images/hobbies.png',
                      text: 'Edit Preferences',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPreferences(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/choices.png',
                      text: 'Edit Interest',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditInterest(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/translation.png',
                      text: 'Edit Language',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditLanguage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/setting.png',
                      text: 'Settings',
                      onClick: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/help.png',
                      text: 'Contact Support',
                      onClick: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/t_and_c.png',
                      text: 'Terms & Conditions',
                      onClick: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileOptionCardItem(
                      icon: 'assets/images/logout.png',
                      text: 'Logout',
                      onClick: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOptionCardItem extends StatelessWidget {
  const ProfileOptionCardItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onClick,
  });
  final String icon;
  final String text;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => onClick(),
      child: Container(
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: MyColors.bottomBarColor(context),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Image.asset(
                  icon,
                  color: MyColors.constTheme,
                  height: 20,
                  width: 20,
                ),
                MyBoldText(
                  text: text,
                  fontSize: 18,
                  color: MyColors.textColor(context),
                ),
              ],
            ),
            IconButton(
              onPressed: () => onClick(),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: MyColors.constTheme,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailSection extends StatelessWidget {
  const ProfileDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/m2.jpg', fit: BoxFit.cover),
        ),
        const SizedBox(height: 15),
        MyBoldText(
          text: 'Emma Whatson',
          fontSize: 22,
          color: MyColors.textColor(context),
        ),
        MyRegularText(
          text: 'Software Engineer',
          fontSize: 16,
          color: MyColors.textLightColor(context),
        ),
      ],
    );
  }
}

class MyProfileAppBarSection extends StatelessWidget {
  const MyProfileAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyBoldText(
            text: 'Profile',
            color: MyColors.textColor(context),
            fontSize: 28,
          ),
          MyIconButton(
            icon: 'assets/images/edit.png',
            padding: 12,
            size: 20,
            onClick: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              ),
            },
          ),
        ],
      ),
    );
  }
}
