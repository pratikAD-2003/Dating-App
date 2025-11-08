import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class EditLanguage extends StatefulWidget {
  const EditLanguage({super.key});

  @override
  State<EditLanguage> createState() => _EditLanguageState();
}

class _EditLanguageState extends State<EditLanguage> {
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
              Row(
                spacing: 15,
                children: [
                  MyBackButton(),
                  MyBoldText(
                    text: 'Update Languages',
                    color: MyColors.textColor(context),
                    fontSize: 22,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
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
                child: MyButton(text: 'Continue', onClick: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
