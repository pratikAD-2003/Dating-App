import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/profile/location_screen.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, required this.interests});
  final List<String> interests;
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<String> options = [
    "English",
    "Hindi",
    "Spanish",
    "French",
    "German",
    "Mandarin",
    "Japanese",
    "Korean",
    "Arabic",
    "Portuguese",
    "Italian",
    "Russian",
    "Bengali",
    "Urdu",
    "Turkish",
    "Tamil",
    "Telugu",
    "Marathi",
    "Gujarati",
    "Punjabi",
  ];

  List<String> selectedLanguages = [];

  void toggleSelection(String language) {
    setState(() {
      if (selectedLanguages.contains(language)) {
        selectedLanguages.remove(language);
      } else {
        selectedLanguages.add(language);
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
                        text: 'Languages you know',
                        color: MyColors.textColor(context),
                        fontSize: 28,
                      ),
                      const SizedBox(height: 5),
                      MyRegularText(
                        text:
                            "Select your preferred languages to connect better.",
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
                            final isSelected = selectedLanguages.contains(
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
                          return LocationScreen(
                            interests: widget.interests,
                            languages: selectedLanguages,
                          );
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
