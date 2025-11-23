import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/user/get_requested_match_users_res_model.dart';
import 'package:dating_app/data/riverpod/user_notifier.dart';
import 'package:dating_app/presentation/bottom_nav/my_matches_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/components/shimmer_layouts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/presentation/user/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
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
          .read(getFavoriteMatchesProvider.notifier)
          .getFavoriteUsers(userId ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getFavoriteMatchesProvider, (previous, next) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  MyBackButton(),
                  MyBoldText(
                    text: 'Favorites',
                    color: MyColors.textColor(context),
                    fontSize: 28,
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
                            "This is a list of people who have you marked as favorite.",
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
                              itemCount: (requestedUsersList.length / 2).ceil(),
                              itemBuilder: (context, index) {
                                int first = index * 2;
                                int? second =
                                    first + 1 < requestedUsersList.length
                                    ? first + 1
                                    : null;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // First card
                                    Expanded(
                                      child: UserMatchedCard(
                                        name:
                                            requestedUsersList[first]
                                                .fullName ??
                                            "N/A",
                                        icon:
                                            requestedUsersList[first]
                                                .profilePhotoUrl ??
                                            "",
                                        age:
                                            requestedUsersList[first].age ?? -1,
                                        onAccepted: () {},
                                        onRejected: () {},
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailScreen(
                                                    userId:
                                                        requestedUsersList[first]
                                                            .userId ??
                                                        "",
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    // Second card (if available)
                                    if (second != null)
                                      Expanded(
                                        child: UserMatchedCard(
                                          name:
                                              requestedUsersList[second]
                                                  .fullName ??
                                              "N/A",
                                          icon:
                                              requestedUsersList[second]
                                                  .profilePhotoUrl ??
                                              "",
                                          age:
                                              requestedUsersList[second].age ??
                                              -1,
                                          onAccepted: () {},
                                          onRejected: () {},
                                          onClick: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserDetailScreen(
                                                      userId:
                                                          requestedUsersList[second]
                                                              .userId ??
                                                          "",
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (second == null) Spacer(),
                                  ],
                                );
                              },
                            )
                          : SizedBox(
                              height: 600,
                              child: Center(
                                child: MyRegularText(
                                  text: 'No one marked as favorite.',
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
