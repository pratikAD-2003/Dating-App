import 'dart:ui';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/user/get_home_users_res_model.dart';
import 'package:dating_app/data/riverpod/user_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/components/shimmer_layouts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/presentation/user/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcard/tcard.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TCardController _controller = TCardController();

  String? currentCity;
  String? userId;
  bool _isLoading = true;
  List<Users> homeUsersList = [];
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final city = await PrefsHelper.getLocationCity();
    final id = await PrefsHelper.getUserId();
    setState(() {
      currentCity = city;
      userId = id;
    });
    if (userId != null) {
      await ref
          .read(getHomeMatchesProvider.notifier)
          .getHomeMatches(userId ?? " ");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getHomeMatchesProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            setState(() {
              homeUsersList = user.users ?? [];
            });
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HomeBar(
                  location: currentCity ?? "",
                  onLocation: () {},
                  onFilter: () {},
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: _isLoading
                        ? HomeShimmerLy()
                        : homeUsersList.isNotEmpty
                        ? TCard(
                            controller: _controller,
                            size: Size(
                              MediaQuery.of(context).size.width * 0.95,
                              MediaQuery.of(context).size.height * 0.60,
                            ),
                            cards: homeUsersList
                                .map(
                                  (e) => HomeCardLy(
                                    job: e.profession ?? "",
                                    icon: e.profilePhotoUrl ?? "",
                                    age: e.age ?? -1,
                                    distance: e.distance ?? 0,
                                    name: e.fullName ?? "",
                                    onSwipeLeft: () {},
                                    onSwipeRight: () {},
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserDetailScreen(
                                                userId: e.userId ?? "",
                                              ),
                                        ),
                                      );
                                    },
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
                          )
                        : MyRegularText(
                            text: 'Users not found!',
                            color: MyColors.textLight2Color(context),
                          ),
                  ),
                ),
                if (!_isLoading && homeUsersList.isNotEmpty)
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
    required this.job,
    this.onSwipeLeft,
    this.onSwipeRight,
    required this.onClick,
  });
  final String icon;
  final num distance;
  final int age;
  final String name;
  final String job;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback onClick;

  @override
  State<HomeCardLy> createState() => _HomeCardLyState();
}

class _HomeCardLyState extends State<HomeCardLy> {
  double dragValue = 0.0; // to track swipe progress
  String direction = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
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
        borderRadius: BorderRadius.circular(15),
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
                  child: Image.network(widget.icon, fit: BoxFit.cover),
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
                              fontSize: 24,
                            ),
                            MyRegularText(
                              text: widget.job,
                              color: MyColors.constWhite,
                              fontSize: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/love_birds.png",
                height: 48,
                width: 48,
                color: MyColors.constTheme,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBoldText(
                    text: 'Discover',
                    color: MyColors.textColor(context),
                  ),
                  MyRegularText(
                    text: location,
                    color: MyColors.textLightColor(context),
                    fontSize: 15,
                  ),
                ],
              ),
            ],
          ),
          MyIconButton(
            icon: 'assets/images/star.png',
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
