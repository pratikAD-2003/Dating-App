import 'package:dating_app/data/model/request/auth/forget/reset_pass_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPassScreen extends ConsumerStatefulWidget {
  const ResetPassScreen({super.key, required this.email});
  final String email;
  @override
  ConsumerState<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends ConsumerState<ResetPassScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      emailController.text = widget.email;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(resetPassNotifierProvider);

    ref.listen(resetPassNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Password reset successfully.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) {
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
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/love_birds.png',
                      height: 90,
                      width: 90,
                      color: MyColors.constTheme,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyBoldText(
                            text: 'Reset Password',
                            fontSize: 20,
                            color: MyColors.textColor(context),
                          ),
                          SizedBox(height: 40),
                          MyInputField(
                            controller: emailController,
                            hintText: 'Email Address',
                            onRead: true,
                            condition: (text) {
                              return text.endsWith("@gmail.com");
                            },
                          ),
                          SizedBox(height: 15),
                          PasswordField(
                            controller: passController,
                            hintText: 'Create Password',
                          ),
                          SizedBox(height: 15),
                          PasswordField(
                            controller: confirmPassController,
                            hintText: 'Confirm Password',
                          ),
                          SizedBox(height: 30),
                          MyButton(
                            text: 'Update Password',
                            isLoading: authState.isLoading,
                            onClick: () async {
                              ResetPassReqModel data = ResetPassReqModel(
                                email: emailController.text,
                                newPassword: confirmPassController.text,
                              );
                              await ref
                                  .read(resetPassNotifierProvider.notifier)
                                  .resetPassword(data.toJson());
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
