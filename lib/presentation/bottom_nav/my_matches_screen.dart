import 'dart:ui';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/user/get_requested_match_users_res_model.dart';
import 'package:dating_app/data/riverpod/user_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/components/shimmer_layouts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/presentation/user/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyMatchesScreen extends ConsumerStatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  ConsumerState<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends ConsumerState<MyMatchesScreen> {
  String? userId;
  bool _isLoading = true;
  List<Users> requestedUsersList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final id = await PrefsHelper.getUserId();
    setState(() {
      userId = id;
    });
    if (userId != null) {
      await ref
          .read(getRequestedMatchesProvider.notifier)
          .getRequestedMathces(userId ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getRequestedMatchesProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            setState(() {
              requestedUsersList = user.users ?? [];
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
                      SizedBox(height: 20),
                      _isLoading
                          ? RequestMatchesShimmerLy()
                          : requestedUsersList.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: requestedUsersList.length,
                              itemBuilder: (context, index) {
                                // Even index = row with 2 cards
                                int rowIndex = index ~/ 2;
                                int first = rowIndex * 2;
                                int? second =
                                    first + 1 < requestedUsersList.length
                                    ? first + 1
                                    : null;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: UserMatchedCard(
                                        name:
                                            requestedUsersList[index]
                                                .fullName ??
                                            "N/A",
                                        icon:
                                            requestedUsersList[index]
                                                .profilePhotoUrl ??
                                            "",
                                        age:
                                            requestedUsersList[index].age ?? -1,
                                        onAccepted: () {},
                                        onRejected: () {},
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailScreen(
                                                    userId:
                                                        requestedUsersList[index]
                                                            .userId ??
                                                        "",
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    if (second != null)
                                      Expanded(
                                        child: UserMatchedCard(
                                          name:
                                              requestedUsersList[index]
                                                  .fullName ??
                                              "N/A",
                                          icon:
                                              requestedUsersList[index]
                                                  .profilePhotoUrl ??
                                              "",
                                          age:
                                              requestedUsersList[index].age ??
                                              -1,
                                          onAccepted: () {},
                                          onRejected: () {},
                                          onClick: () {},
                                        ),
                                      ),
                                    if (second == null)
                                      const Spacer(), // fill space for odd items
                                  ],
                                );
                              },
                            )
                          : SizedBox(
                              height: 600,
                              child: Center(
                                child: MyRegularText(
                                  text: 'No match request received.',
                                  color: MyColors.textLight2Color(context),
                                ),
                              ),
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
    required this.onRejected,
    required this.onAccepted,
    required this.onClick,
  });
  final String name;
  final String icon;
  final int age;
  final VoidCallback onRejected;
  final VoidCallback onAccepted;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
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
                  child: Image.network(icon, fit: BoxFit.cover),
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
                            filter: ImageFilter.blur(
                              sigmaX: 15.0,
                              sigmaY: 15.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                  0.2,
                                ), // Transparent layer
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => onRejected(),
                                      child: Image.asset(
                                        'assets/images/close.png',
                                        color: MyColors.constWhite,
                                        height: 28,
                                        width: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: MyColors.constWhite,
                                    height: 45,
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => onAccepted(),
                                      child: Image.asset(
                                        'assets/images/heart.png',
                                        color: MyColors.constWhite,
                                        height: 20,
                                        width: 20,
                                      ),
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
      ),
    );
  }
}
