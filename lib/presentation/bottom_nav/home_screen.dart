import 'dart:ui';

import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TCardController _controller = TCardController();

  final List<SampleModel> sampleList = [
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 3,
      age: 22,
      name: 'Jessica Parker',
    ),
    SampleModel(
      icon: 'assets/images/m3.jpg',
      distance: 5,
      age: 24,
      name: 'Sophia Turner',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 2,
      age: 21,
      name: 'Olivia Martin',
    ),
    SampleModel(
      icon: 'assets/images/m3.jpg',
      distance: 4,
      age: 25,
      name: 'Ava Johnson',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 6,
      age: 23,
      name: 'Emily Davis',
    ),
    SampleModel(
      icon: 'assets/images/m3.jpg',
      distance: 1,
      age: 26,
      name: 'Isabella Clark',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 7,
      age: 24,
      name: 'Mia Wilson',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 3,
      age: 22,
      name: 'Amelia Lewis',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 8,
      age: 27,
      name: 'Ella Walker',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 2,
      age: 23,
      name: 'Harper Young',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 5,
      age: 25,
      name: 'Grace Hall',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 4,
      age: 26,
      name: 'Chloe Allen',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 6,
      age: 24,
      name: 'Lily Scott',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 7,
      age: 28,
      name: 'Zoe Adams',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 3,
      age: 23,
      name: 'Layla Moore',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 5,
      age: 22,
      name: 'Aria White',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 2,
      age: 24,
      name: 'Scarlett King',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 4,
      age: 25,
      name: 'Victoria Lee',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 6,
      age: 27,
      name: 'Hannah Baker',
    ),
    SampleModel(
      icon: 'assets/images/m2.jpg',
      distance: 8,
      age: 26,
      name: 'Nora Evans',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomeBar(
                  location: 'Mumbai, India',
                  onLocation: () {},
                  onFilter: () {},
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: TCard(
                      controller: _controller,
                      size: Size(
                        MediaQuery.of(context).size.width * 0.95,
                        MediaQuery.of(context).size.height * 0.60,
                      ),
                      cards: sampleList
                          .map(
                            (e) => HomeCardLy(
                              icon: e.icon,
                              age: e.age,
                              distance: e.distance,
                              name: e.name,
                              onSwipeLeft: () {},
                              onSwipeRight: () {},
                            ),
                          )
                          .toList(),
                      onForward: (index, info) {
                        debugPrint(
                          "Swiped ${info.direction == SwipDirection.Left ? "Left ❌" : "Right ❤️"}",
                        );
                      },
                      onEnd: () {
                        debugPrint("All cards swiped!");
                      },
                    ),
                  ),
                ),
                HomeBottomSection(
                  onReject: () {
                    _controller.forward(direction: SwipDirection.Left);
                  },
                  onAccept: () {
                    _controller.forward(direction: SwipDirection.Right);
                  },
                  onFavorite: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCardLy extends StatefulWidget {
  const HomeCardLy({
    super.key,
    required this.icon,
    required this.distance,
    required this.age,
    required this.name,
    this.onSwipeLeft,
    this.onSwipeRight,
  });
  final String icon;
  final int distance;
  final int age;
  final String name;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  @override
  State<HomeCardLy> createState() => _HomeCardLyState();
}

class _HomeCardLyState extends State<HomeCardLy> {
  double dragValue = 0.0; // to track swipe progress
  String direction = "";

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onPanStart: (_) {
        // reset when new drag starts
        dragValue = 0;
        direction = "";
      },
      onPanUpdate: (details) {
        // track horizontal drag
        setState(() {
          dragValue += details.delta.dx;

          // detect direction
          if (details.delta.dx > 0) {
            direction = "right";
          } else if (details.delta.dx < 0) {
            direction = "left";
          }
        });
      },
      onPanEnd: (details) {
        // check threshold for complete swipe
        if (dragValue > 100) {
          widget.onSwipeRight?.call();
        } else if (dragValue < -100) {
          widget.onSwipeLeft?.call();
        }

        // reset
        setState(() {
          dragValue = 0;
          direction = "";
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(15),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.55,
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
                  child: Image.asset(widget.icon, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColors.constWhite.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 2,
                      children: [
                        Image.asset(
                          'assets/images/location.png',
                          color: MyColors.constWhite,
                          height: 18,
                          width: 18,
                        ),
                        MyBoldText(
                          text: '${widget.distance} km',
                          color: MyColors.constWhite,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            0.2,
                          ), // Transparent layer
                        ),
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyBoldText(
                              text: "${widget.name}, ${widget.age}",
                              color: MyColors.constWhite,
                              fontSize: 26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // trigger when swipping
                if (direction.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Center(
                      child: MyCircularElevatedBtn(
                        icon: direction == "left"
                            ? 'assets/images/close.png'
                            : 'assets/images/heart.png',
                        cardColor: MyColors.themeColor(context),
                        iconColor: MyColors.constOrg,
                        size: 75,
                        iconSize: 35,
                        onClick: () => {},
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeBar extends StatelessWidget {
  const HomeBar({
    super.key,
    required this.location,
    required this.onLocation,
    required this.onFilter,
  });
  final String location;
  final VoidCallback onLocation;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyIconButton(
            icon: 'assets/images/location.png',
            padding: 12,
            size: 20,
            onClick: () => onLocation(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyBoldText(text: 'Discover', color: MyColors.textColor(context)),
              MyRegularText(
                text: location,
                color: MyColors.textLightColor(context),
                fontSize: 15,
              ),
            ],
          ),
          MyIconButton(
            icon: 'assets/images/filter.png',
            padding: 12,
            size: 20,
            onClick: () => onFilter(),
          ),
        ],
      ),
    );
  }
}

class HomeBottomSection extends StatelessWidget {
  const HomeBottomSection({
    super.key,
    required this.onReject,
    required this.onAccept,
    required this.onFavorite,
  });
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          MyCircularElevatedBtn(
            icon: 'assets/images/close.png',
            cardColor: MyColors.themeColor(context),
            iconColor: MyColors.constOrg,
            size: 75,
            iconSize: 40,
            onClick: () => onReject(),
          ),
          MyCircularElevatedBtn(
            icon: 'assets/images/heart.png',
            size: 105,
            iconSize: 45,
            onClick: () => onAccept(),
          ),
          MyCircularElevatedBtn(
            icon: 'assets/images/star.png',
            cardColor: MyColors.themeColor(context),
            iconColor: MyColors.constBrinj,
            size: 75,
            iconSize: 32,
            onClick: () => onFavorite(),
          ),
        ],
      ),
    );
  }
}

class MyCircularElevatedBtn extends StatelessWidget {
  const MyCircularElevatedBtn({
    super.key,
    this.cardColor = MyColors.constTheme,
    required this.icon,
    this.iconColor = MyColors.constWhite,
    this.elevation = 0,
    this.size = 80,
    this.iconSize = 30, // 🔹 New attribute to control image size
    required this.onClick,
  });

  final VoidCallback onClick;
  final Color cardColor;
  final Color iconColor;
  final String icon;
  final double elevation;
  final double size;
  final double iconSize; // 🔹 New property

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(50),
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
        // shadowColor: MyColors.borderColor(context),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: MyColors.hintColor(context).withValues(alpha: 0.2),
                blurRadius: 2,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Image.asset(
            icon,
            color: iconColor,
            height: iconSize, // 🔹 Use iconSize here
            width: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class SampleModel {
  final String icon;
  final int distance;
  final int age;
  final String name;

  SampleModel({
    required this.icon,
    required this.distance,
    required this.age,
    required this.name,
  });

  // Optional: If you ever want to use JSON (API integration)
  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      icon: json['icon'],
      distance: json['distance'],
      age: json['age'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'icon': icon, 'distance': distance, 'age': age, 'name': name};
  }
}
