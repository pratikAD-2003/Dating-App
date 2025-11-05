import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/presentation/auth/login_screen.dart';
import 'package:dating_app/presentation/auth/signup_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> images = [
    "assets/images/m1.png",
    "assets/images/m2.jpg",
    "assets/images/m3.jpg",
  ];

  List<String> titleText = ["Algorithm", "Matches", "Premium"];
  List<String> subText = [
    "Users going through a vetting process to ensure you never match with bots.",
    "We match you with people that have a large array of similar interests.",
    "Sign up today and enjoy the first month of preminum benefits on us.",
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    OnBoardingBanner(
                      images: images,
                      onChange: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    MyBoldText(
                      text: titleText[currentIndex],
                      color: MyColors.constTheme,
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: MyRegularText(
                        text: subText[currentIndex],
                        color: MyColors.textLight2Color(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images
                          .asMap()
                          .entries
                          .map(
                            (item) => Container(
                              height: 10,
                              width: 10,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == item.key
                                    ? MyColors.constTheme
                                    : MyColors.btmNavUnSelected,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MyButton(
                        text: 'Create an account',
                        isLoading: false,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    AuthRememberText(
                      mainText: 'Already have an account?',
                      endText: 'Sign In',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthRememberText extends StatelessWidget {
  const AuthRememberText({
    super.key,
    required this.mainText,
    required this.endText,
    required this.onClick,
  });
  final String mainText;
  final String endText;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        MyRegularText(
          text: mainText,
          color: MyColors.textLightColor(context),
          textAlign: TextAlign.center,
        ),
        InkWell(
          onTap: () => onClick(),
          child: MyBoldText(
            text: endText,
            color: MyColors.constTheme,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class OnBoardingBanner extends StatefulWidget {
  final List<String> images;
  final Function(int currentIndex) onChange;
  const OnBoardingBanner({
    super.key,
    required this.images,
    required this.onChange,
  });

  @override
  State<OnBoardingBanner> createState() => _OnBoardingBannerState();
}

class _OnBoardingBannerState extends State<OnBoardingBanner> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: widget.images
              .map(
                (item) => Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: 380,
            // autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.70,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
                widget.onChange(currentIndex);
              });
            },
          ),
        ),
      ],
    );
  }
}
