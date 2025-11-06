import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/language_screen.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<String> options = [
    "Music",
    "Traveling",
    "Cooking",
    "Movies",
    "Reading",
    "Fitness",
    "Dancing",
    "Photography",
    "Gaming",
    "Yoga",
    "Pets",
    "Art",
    "Foodie",
    "Sports",
    "Adventure",
    "Nature",
    "Fashion",
    "Meditation",
    "Partying",
    "Technology",
  ];

  List<String> selectedInterests = [];

  void toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
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
                        backEnable: true,
                        onClick: () {},
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      MyBoldText(
                        text: 'Your Interests',
                        color: MyColors.textColor(context),
                        fontSize: 28,
                      ),
                      const SizedBox(height: 5),
                      MyRegularText(
                        text:
                            "Select few of yours interests and let everyone know about you're passinate about.",
                        color: MyColors.textLightColor(context),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GridView.builder(
                          shrinkWrap:
                              true, // ✅ makes GridView take only required space
                          physics:
                              const NeverScrollableScrollPhysics(), // ✅ disable internal scroll
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 items per row
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio:
                                    2.8, // adjust width/height ratio as needed
                              ),
                          itemCount: options.length, // ✅ must include itemCount
                          itemBuilder: (context, index) {
                            final isSelected = selectedInterests.contains(
                              options[index],
                            );
                            return OptionCard(
                              text: options[index],
                              isSelected: isSelected,
                              onClick: () => toggleSelection(options[index]),
                            );
                          },
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
                          return LanguageScreen();
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

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onClick,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(15),
      child: Material(
        elevation: isSelected ? 3 : 0,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? MyColors.constTheme
                : MyColors.background(context),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: MyColors.borderColor(context),
              width: isSelected ? 0 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: MyBoldText(
            fontSize: 16,
            text: text,
            color: isSelected
                ? MyColors.constWhite
                : MyColors.textColor(context),
          ),
        ),
      ),
    );
  }
}
