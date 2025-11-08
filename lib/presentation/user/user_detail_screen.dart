import 'package:dating_app/presentation/bottom_nav/home_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Image.asset(
                      'assets/images/m2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(left: 20, top: 20, child: MyBackButton()),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 260,
              bottom: 0,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 65,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.background(context),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeBottomSection(
                          onReject: () {},
                          onAccept: () {},
                          onFavorite: () {},
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),

                                  UserDetailNameLableSection(),
                                  SizedBox(height: 30),
                                  UserDetailsLocationSection(),
                                  SizedBox(height: 30),
                                  UserDetailsAboutSection(),
                                  SizedBox(height: 30),
                                  UserDetailsInterestSection(),
                                  SizedBox(height: 30),
                                  UserDetailsLanguageSection(),
                                  SizedBox(height: 30),
                                  UserDetailsGallerySection(
                                    images: [
                                      'assets/images/m2.jpg',
                                      'assets/images/m3.jpg',
                                      'assets/images/m2.jpg',
                                      'assets/images/m3.jpg',
                                      'assets/images/m2.jpg',
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsGallerySection extends StatelessWidget {
  final List<String> images;

  const UserDetailsGallerySection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox(); // No gallery
    }

    // Split images
    final firstImages = images.take(2).toList(); // first up to 3
    final remainingImages = images.skip(2).toList(); // rest small

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyBoldText(
              text: 'Gallery',
              color: MyColors.textColor(context),
              fontSize: 18,
            ),
            InkWell(
              onTap: () {},
              child: MyBoldText(
                text: 'See all',
                color: MyColors.constTheme,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // 🔹 Large Top Images
        Row(
          spacing: 10,
          children: firstImages.map((img) {
            return Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(img, fit: BoxFit.cover, height: 220),
              ),
            );
          }).toList(),
        ),

        if (remainingImages.isNotEmpty) ...[
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: remainingImages.map((img) {
              return SizedBox(
                width:
                    (MediaQuery.of(context).size.width - 60) / 3, // 3 per row
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(img, fit: BoxFit.cover),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class UserDetailsInterestSection extends StatelessWidget {
  const UserDetailsInterestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        MyBoldText(
          text: 'Interests',
          color: MyColors.textColor(context),
          fontSize: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: MyColors.background(context),
            border: Border.all(width: 1.5, color: MyColors.constTheme),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Image.asset(
                'assets/images/done-all.png',
                color: MyColors.constTheme,
                height: 22,
                width: 22,
              ),
              MyBoldText(
                text: 'Sports',
                fontSize: 15,
                color: MyColors.constTheme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetailsLanguageSection extends StatelessWidget {
  const UserDetailsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        MyBoldText(
          text: 'Languages',
          color: MyColors.textColor(context),
          fontSize: 18,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: MyColors.background(context),
            border: Border.all(width: 1.5, color: MyColors.constTheme),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Image.asset(
                'assets/images/done-all.png',
                color: MyColors.constTheme,
                height: 22,
                width: 22,
              ),
              MyBoldText(
                text: 'English',
                fontSize: 15,
                color: MyColors.constTheme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetailsAboutSection extends StatelessWidget {
  const UserDetailsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyBoldText(
          text: 'About',
          color: MyColors.textColor(context),
          fontSize: 18,
        ),
        MyRegularText(
          text:
              'My name is Emma Whatson and i enjoy meeting new people and fiding ways to help them have an uplifting experience.',
          fontSize: 16,
          color: MyColors.textLightColor(context),
        ),
      ],
    );
  }
}

class UserDetailsLocationSection extends StatelessWidget {
  const UserDetailsLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyBoldText(
              text: 'Location',
              color: MyColors.textColor(context),
              fontSize: 18,
            ),
            MyRegularText(
              text: 'Mumbai, India',
              fontSize: 16,
              color: MyColors.textLightColor(context),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColors.chatBoxColor(context),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              Image.asset(
                'assets/images/location.png',
                color: MyColors.constTheme,
                height: 18,
                width: 18,
              ),
              MyBoldText(
                text: '4 km',
                color: MyColors.constTheme,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetailNameLableSection extends StatelessWidget {
  const UserDetailNameLableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyBoldText(
                  text: 'Emma Whatson, 22',
                  color: MyColors.textColor(context),
                  fontSize: 22,
                ),
                MyRegularText(
                  text: 'Software Engineer',
                  fontSize: 16,
                  color: MyColors.textLightColor(context),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColors.chatBoxColor(context),
                ),
                height: 55,
                width: 55,
                child: Icon(
                  Icons.message,
                  color: MyColors.constTheme,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
