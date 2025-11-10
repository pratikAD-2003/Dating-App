import 'package:dating_app/data/model/request/auth/signup/verify_otp_signup_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  const VerifyOtp({super.key, required this.email});
  final String email;
  @override
  ConsumerState<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  final controllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(verifySignupEmailNotifierProvider);

    ref.listen(verifySignupEmailNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Signup successfully.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfile()),
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
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyBackButton(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyBoldText(
                      text: 'Verify OTP',
                      fontSize: 26,
                      color: MyColors.textColor(context),
                    ),
                    SizedBox(height: 30),
                    MyRegularText(
                      text: "A 4 Digits OTP has been sent to your",
                      color: MyColors.textLightColor(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    MyRegularText(
                      text: '+91 5856584558',
                      color: MyColors.textLight2Color(context),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: OtpInputField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            nextNode: index < 3 ? focusNodes[index + 1] : null,
                            previousNode: index > 0
                                ? focusNodes[index - 1]
                                : null,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 50),
                        MyButton(
                          text: 'Verify',
                          isLoading: authState.isLoading,
                          onClick: () async{
                            final otp = controllers.map((e) => e.text).join();

                            final data = VerifyOtpSignupReqModel(
                              email: widget.email,
                              otp: double.parse(otp).toInt(),
                            );
                            await ref
                                .read(
                                  verifySignupEmailNotifierProvider.notifier,
                                )
                                .verifyEmailSignup(data.toJson());
                          },
                        ),
                        SizedBox(height: 30),
                        Row(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyRegularText(
                              text: "Resend OTP",
                              color: MyColors.textLightColor(context),
                            ),
                            MyRegularText(
                              text: "(00:12)",
                              fontSize: 18,
                              color: MyColors.constTheme,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
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
