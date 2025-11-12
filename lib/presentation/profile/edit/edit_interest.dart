import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/request/profile/update_interest_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditInterest extends ConsumerStatefulWidget {
  const EditInterest({super.key});

  @override
  ConsumerState<EditInterest> createState() => _EditInterestState();
}

class _EditInterestState extends ConsumerState<EditInterest> {
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
  String? userId;
  bool _isLoading = true;

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
  void initState() {
    _loadProfileData();
    super.initState();
  }

  Future<void> _loadProfileData() async {
    final interests = await PrefsHelper.getInterests();
    String? id = await PrefsHelper.getUserId();

    setState(() {
      userId = id;
      selectedInterests = interests ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(updateInterestNotifierProvider);

    ref.listen(updateInterestNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            await PrefsHelper.saveInterests(interests: user.data);
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Interests Updated.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2),
            );

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(snackBar).closed.then((_) async {});
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
        },
      );
    });

    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: MyColors.constTheme),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20,
                ),
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
                                itemCount:
                                    options.length, // ✅ must include itemCount
                                itemBuilder: (context, index) {
                                  final isSelected = selectedInterests.contains(
                                    options[index],
                                  );
                                  return OptionCard(
                                    text: options[index],
                                    isSelected: isSelected,
                                    onClick: () =>
                                        toggleSelection(options[index]),
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
                        text: 'Update',
                        isLoading: authState.isLoading,
                        onClick: () async {
                          UpdateInterestReqModel data = UpdateInterestReqModel(
                            userId: userId,
                            interests: selectedInterests,
                          );
                          await ref
                              .read(updateInterestNotifierProvider.notifier)
                              .updateInterest(data.toJson());
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
