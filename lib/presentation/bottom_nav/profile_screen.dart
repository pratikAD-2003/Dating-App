import 'package:dating_app/data/local/google_signing_manager.dart';
import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/edit/edit_interest.dart';
import 'package:dating_app/presentation/profile/edit/edit_language.dart';
import 'package:dating_app/presentation/profile/edit/edit_preferences.dart';
import 'package:dating_app/presentation/profile/edit/edit_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late GoogleSignInManager googleSignInManager;
  String? profilePhotoUrl;
  String? fullName;
  String? profession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // call async function safely
    googleSignInManager = GoogleSignInManager(
      onSuccess: (email, name, photoUrl, idToken) {},
      onFailure: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MyBoldText(
              text: message,
              fontSize: 16,
              color: MyColors.themeColor(context),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadProfileData() async {
    final photo = await PrefsHelper.getProfilePhotoUrl();
    final name = await PrefsHelper.getFullName();
    final job = await PrefsHelper.getProfession();
    String? userId = await PrefsHelper.getUserId();

    if ((photo == null || name == null || job == null) && userId != null) {
      // Fetch from API if not available locally
      await ref
          .read(getUserDetailsNotifierProvider.notifier)
          .getUserDetails(userId);
    } else {
      // Update UI if data found locally
      setState(() {
        profilePhotoUrl = photo;
        fullName = name;
        profession = job;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getUserDetailsNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            await PrefsHelper.saveUserProfile(
              bio: user.data?.profile?.bio,
              dateOfBirth: user.data?.profile?.dateOfBirth,
              fullName: user.data?.profile?.fullName,
              gender: user.data?.profile?.gender,
              profession: user.data?.profile?.profession,
              profilePhotoUrl: user.data?.profile?.profilePhotoUrl,
            );
            await PrefsHelper.saveUserPref(
              ageMin: user.data?.preferences?.ageRangePreference?.min,
              ageMax: user.data?.preferences?.ageRangePreference?.max,
              locationType: "Point",
              locationLat: user.data?.preferences?.location?.coordinates?.first,
              locationLng: user.data?.preferences?.location?.coordinates?.last,
              locationCity: user.data?.preferences?.location?.city,
              locationCountry: user.data?.preferences?.location?.country,
              distancePreference: user.data?.preferences?.distancePreference,
              gallery: user.data?.preferences?.gallery,
              genderPreference: user.data?.preferences?.genderPreference,
              interests: user.data?.preferences?.interests,
              languages: user.data?.preferences?.languages,
            );

            // Update UI after data save
            _loadProfileData();
            setState(() => _isLoading = false);
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
          setState(() => _isLoading = false);
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
            : Column(
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
                          ProfileDetailSection(
                            image: profilePhotoUrl,
                            name: fullName,
                            profession: profession,
                          ),
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
                            onClick: () async {
                              await PrefsHelper.clearAll();
                              await googleSignInManager.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnboardingScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
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
  const ProfileDetailSection({
    super.key,
    this.image,
    this.name,
    this.profession,
  });
  final String? image;
  final String? name;
  final String? profession;

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
          child: image != null
              ? Image.network(image!, fit: BoxFit.cover)
              : Image.asset('assets/images/m2.jpg', fit: BoxFit.cover),
        ),
        const SizedBox(height: 15),
        MyBoldText(
          text: name ?? "N/A",
          fontSize: 22,
          color: MyColors.textColor(context),
        ),
        MyRegularText(
          text: profession ?? "N/A",
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
