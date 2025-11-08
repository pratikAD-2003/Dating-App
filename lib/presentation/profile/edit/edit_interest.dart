import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class EditInterest extends StatefulWidget {
  const EditInterest({super.key});

  @override
  State<EditInterest> createState() => _EditInterestState();
}

class _EditInterestState extends State<EditInterest> {
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
              Row(
                spacing: 15,
                children: [
                  MyBackButton(),
                  MyBoldText(
                    text: 'Update Interest',
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
                child: MyButton(text: 'Update', onClick: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
