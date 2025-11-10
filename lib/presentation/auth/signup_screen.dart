import 'package:dating_app/data/model/request/auth/login/login_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/login_screen.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/auth/verify_otp.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_divider.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(signupNotifierProvider);

    ref.listen(signupNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Otp sent to your email.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) {
              // ✅ Navigate only after snackbar disappears
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyOtp(email: emailController.text),
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
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.app_registration, size: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyBoldText(
                      text: 'Sign up to continue',
                      fontSize: 20,
                      color: MyColors.textColor(context),
                    ),
                    SizedBox(height: 40),
                    MyInputField(
                      controller: emailController,
                      hintText: 'Email Address',
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
                      text: 'Create account',
                      isLoading: authState.isLoading,
                      onClick: () async{
                        LoginReqModel data = LoginReqModel(
                          email: emailController.text,
                          password: confirmPassController.text,
                        );
                        await ref
                            .read(signupNotifierProvider.notifier)
                            .signup(data.toJson());
                      },
                    ),
                    SizedBox(height: 40),
                    MyDivider(dividerText: 'or sign up with'),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 25,
                      children: [
                        MyIconButton(
                          icon: 'assets/images/fb.png',
                          onClick: () {},
                        ),
                        MyIconButton(
                          icon: 'assets/images/google.png',
                          onClick: () {},
                        ),
                        MyIconButton(
                          icon: 'assets/images/apple.png',
                          onClick: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    AuthRememberText(
                      mainText: "Already have an account?",
                      endText: 'Sign In',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
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
