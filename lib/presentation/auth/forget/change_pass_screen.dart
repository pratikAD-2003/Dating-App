import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/request/auth/forget/change_pass_req_mode.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassScreen extends ConsumerStatefulWidget {
  const ChangePassScreen({super.key});

  @override
  ConsumerState<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends ConsumerState<ChangePassScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? email;
  bool _isLoading = true;

  @override
  void initState() {
    _loadProfileData();
    super.initState();
  }

  Future<void> _loadProfileData() async {
    final e = await PrefsHelper.getEmail();

    // Update UI if data found locally
    setState(() {
      email = e;
      emailController.text = email ?? "";
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(changePassNotifierProvider);

    ref.listen(changePassNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Password Updated.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              Navigator.pop(context);
            });
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
            ? CircularProgressIndicator(color: MyColors.constTheme)
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 15,
                              children: [
                                MyBackButton(),
                                MyBoldText(
                                  text: 'Change Password',
                                  color: MyColors.textColor(context),
                                  fontSize: 24,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Column(
                            spacing: 10,
                            children: [
                              SizedBox(height: 15),
                              MyInputField(
                                controller: emailController,
                                hintText: 'Email Address',
                                onRead: true,
                                condition: (text) {
                                  return text.endsWith("@gmail.com");
                                },
                              ),
                              PasswordField(
                                controller: oldPassController,
                                hintText: 'Old Password',
                              ),
                              PasswordField(
                                controller: passController,
                                hintText: 'New Password',
                              ),
                              PasswordField(
                                controller: confirmPassController,
                                hintText: 'Confirm Password',
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          MyButton(
                            text: 'Change Password',
                            isLoading: authState.isLoading,
                            onClick: () async {
                              ChangePassReqModel data = ChangePassReqModel(
                                email: email,
                                newPassword: confirmPassController.text,
                                oldPassword: oldPassController.text,
                              );
                              await ref
                                  .read(changePassNotifierProvider.notifier)
                                  .changePassword(data.toJson());
                            },
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
