import 'dart:ui';

import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_divider.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyMatchesScreen extends StatelessWidget {
  const MyMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyBoldText(
                    text: 'Matches',
                    color: MyColors.textColor(context),
                    fontSize: 28,
                  ),
                  MyIconButton(
                    icon: 'assets/images/filter.png',
                    padding: 12,
                    size: 20,
                    onClick: () => {},
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyRegularText(
                        text:
                            "This is a list of people who have liked you and your matches.",
                        color: MyColors.textLightColor(context),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (10 / 2).ceil() * 2 - 1, // includes dividers
                        itemBuilder: (context, index) {
                          if (index % 2 == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: MyDivider(
                                dividerText: 'Today',
                                textSize: 14,
                              ),
                            );
                          }

                          // Even index = row with 2 cards
                          int rowIndex = index ~/ 2;
                          int first = rowIndex * 2;
                          int? second = first + 1 < 10 ? first + 1 : null;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: UserMatchedCard(
                                  name: 'User ${first + 1}',
                                  icon: 'assets/images/m2.jpg',
                                  age: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              if (second != null)
                                Expanded(
                                  child: UserMatchedCard(
                                    name: 'User ${second + 1}',
                                    icon: 'assets/images/m3.jpg',
                                    age: 24,
                                  ),
                                ),
                              if (second == null)
                                const Spacer(), // fill space for odd items
                            ],
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
      ),
    );
  }
}

class UserMatchedCard extends StatelessWidget {
  const UserMatchedCard({
    super.key,
    required this.name,
    required this.icon,
    required this.age,
  });
  final String name;
  final String icon;
  final int age;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.40,
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
            color: MyColors.background(context),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(icon, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: MyBoldText(
                        text: "$name, $age",
                        color: MyColors.constWhite,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.directional(
                          bottomEnd: Radius.circular(15),
                          bottomStart: Radius.circular(15),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                0.2,
                              ), // Transparent layer
                            ),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/close.png',
                                    color: MyColors.constWhite,
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                                Container(
                                  color: MyColors.constWhite,
                                  height: 45,
                                  width: 2,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/heart.png',
                                    color: MyColors.constWhite,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
