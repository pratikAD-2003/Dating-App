import 'dart:async';

import 'package:dating_app/data/model/request/auth/forget/forget_pass_req_model.dart';
import 'package:dating_app/data/model/request/auth/forget/verify_otp_forget_pass_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/forget/reset_pass_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtpForgetScreen extends ConsumerStatefulWidget {
  const VerifyOtpForgetScreen({super.key, required this.email});
  final String email;
  @override
  ConsumerState<VerifyOtpForgetScreen> createState() =>
      _VerifyOtpForgetScreenState();
}

class _VerifyOtpForgetScreenState extends ConsumerState<VerifyOtpForgetScreen> {
  final controllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  int seconds = 60;
  Timer? _timer;
  bool resetPassEnable = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    seconds = 60;
    resetPassEnable = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          resetPassEnable = true; // enable resend
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(verifyOtpForgetPassNotifierProvider);
    final sendOtpState = ref.watch(sendOtpForgetPassNotifierProvider);

    ref.listen(verifyOtpForgetPassNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Otp Verified.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPassScreen(email: widget.email),
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
                      text: 'email: ${widget.email}',
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
                          isLoading:
                              authState.isLoading || sendOtpState.isLoading,
                          onClick: () async {
                            final otp = controllers.map((e) => e.text).join();

                            final data = VerifyOtpForgetPassReqModel(
                              email: widget.email,
                              otp: double.parse(otp).toInt(),
                            );
                            await ref
                                .read(
                                  verifyOtpForgetPassNotifierProvider.notifier,
                                )
                                .verifyOtpForFogetPass(data.toJson());
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
                            InkWell(
                              onTap: resetPassEnable
                                  ? () async {
                                      ForgetPassReqModel data =
                                          ForgetPassReqModel(
                                            email: widget.email,
                                          );
                                      await ref
                                          .read(
                                            sendOtpForgetPassNotifierProvider
                                                .notifier,
                                          )
                                          .sendOtpForFogetPass(data.toJson());
                                    }
                                  : null,
                              child: MyRegularText(
                                text: resetPassEnable
                                    ? "Resend"
                                    : "(00:${seconds.toString().padLeft(2, '0')})",
                                fontSize: 18,
                                color: MyColors.constTheme,
                              ),
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
