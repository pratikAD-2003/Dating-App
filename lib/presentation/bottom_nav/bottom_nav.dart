import 'package:dating_app/presentation/bottom_nav/home_screen.dart';
import 'package:dating_app/presentation/bottom_nav/my_matches_screen.dart';
import 'package:dating_app/presentation/bottom_nav/my_messages_screen.dart';
import 'package:dating_app/presentation/bottom_nav/profile_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    MyMatchesScreen(),
    MyMessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: MyColors.bottomBarColor(context),
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavItem(
              iconPath: 'assets/images/home.png',
              isSelected: currentIndex == 0,
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            BottomNavItem(
              iconPath: 'assets/images/heart.png',
              isSelected: currentIndex == 1,
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
            BottomNavItem(
              iconPath: 'assets/images/message.png',
              isSelected: currentIndex == 2,
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
            ),
            BottomNavItem(
              iconPath: 'assets/images/people.png',
              isSelected: currentIndex == 3,
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const BottomNavItem({
    super.key,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
    this.size = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 4,
              width: 55,
              decoration: BoxDecoration(
                color: isSelected
                    ? MyColors.constTheme
                    : MyColors.bottomBarColor(context),
              ),
            ),
            SizedBox(
              width: size, // you can pass size param here
              height: size,
              child: Image.asset(
                iconPath,
                color: isSelected
                    ? MyColors.btmNavSelected
                    : MyColors.btmNavUnSelected,
                fit: BoxFit.contain, // or BoxFit.cover if you want fill
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
