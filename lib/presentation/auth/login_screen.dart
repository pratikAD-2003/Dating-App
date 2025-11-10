import 'package:dating_app/data/model/request/auth/login/login_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/auth/signup_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_divider.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginNotifierProvider);

    ref.listen(loginNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: MyBoldText(
                  text: 'Logged In',
                  fontSize: 16,
                  color: MyColors.themeColor(context),
                ),
              ),
            );
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
                      text: 'Sign In to continue',
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
                      controller: confirmPassController,
                      hintText: 'Password',
                    ),
                    SizedBox(height: 30),
                    MyButton(
                      text: 'Login account',
                      isLoading: authState.isLoading,
                      onClick: () async{
                        LoginReqModel data = LoginReqModel(
                          email: emailController.text,
                          password: confirmPassController.text,
                        );
                        await ref
                            .read(loginNotifierProvider.notifier)
                            .login(data.toJson());
                      },
                    ),
                    SizedBox(height: 40),
                    MyDivider(dividerText: 'or sign in with'),
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
                      mainText: "Didn't have an account?",
                      endText: 'Sign Up',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignupScreen();
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

class TextClickable extends StatelessWidget {
  const TextClickable({super.key, required this.text, required this.onClick});
  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: MyRegularText(
        text: text,
        color: MyColors.constTheme,
        textAlign: TextAlign.center,
      ),
    );
  }
}
