import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final controllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
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
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfile(),
                              ),
                            );
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
