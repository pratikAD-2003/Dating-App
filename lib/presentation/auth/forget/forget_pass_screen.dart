import 'package:dating_app/data/model/request/auth/forget/forget_pass_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/forget/verify_otp_forget_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgetPassScreen extends ConsumerStatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  ConsumerState<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends ConsumerState<ForgetPassScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendOtpState = ref.watch(sendOtpForgetPassNotifierProvider);

    ref.listen(sendOtpForgetPassNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Otp sent to your mail.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerifyOtpForgetScreen(email: emailController.text),
                ),
              );
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
                            text: 'Forget Password',
                            fontSize: 20,
                            color: MyColors.textColor(context),
                          ),
                          SizedBox(height: 20),
                          MyRegularText(
                            text: 'enter your email for verification',
                            color: MyColors.textLight2Color(context),
                          ),
                          SizedBox(height: 40),
                          MyInputField(
                            controller: emailController,
                            hintText: 'Email Address',
                            condition: (text) {
                              return text.endsWith("@gmail.com");
                            },
                          ),
                          SizedBox(height: 40),
                          MyButton(
                            text: 'Continue',
                            isLoading: sendOtpState.isLoading,
                            onClick: () async {
                              ForgetPassReqModel data = ForgetPassReqModel(
                                email: emailController.text,
                              );
                              await ref
                                  .read(
                                    sendOtpForgetPassNotifierProvider.notifier,
                                  )
                                  .sendOtpForFogetPass(data.toJson());
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
