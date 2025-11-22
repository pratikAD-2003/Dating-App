import 'package:dating_app/data/local/google_signing_manager.dart';
import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/google_auth_req_model.dart';
import 'package:dating_app/data/model/request/auth/login/login_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/auth/signup_screen.dart';
import 'package:dating_app/presentation/bottom_nav/bottom_nav.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_divider.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late GoogleSignInManager googleSignInManager;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    googleSignInManager = GoogleSignInManager(
      onSuccess: (email, name, photoUrl, idToken) async {
        setState(() => isLoading = false);
        GoogleAuthReqModel data = GoogleAuthReqModel(token: idToken);
        await ref
            .read(googleAuthNotifierProvider.notifier)
            .googleAuth(data.toJson());
      },
      onFailure: (message) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MyBoldText(
              text: message,
              fontSize: 16,
              color: MyColors.themeColor(context),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginNotifierProvider);
    final googleAuthState = ref.watch(googleAuthNotifierProvider);

    ref.listen(loginNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            await PrefsHelper.saveUserAuth(
              token: user.token,
              email: user.email,
              userId: user.userId,
            );
            await PrefsHelper.saveStatus(
              isLoggedIn: true,
              isProfileUpdated: user.isProfileUpdated,
              isPrefUpdated: user.isPreferenceUpdated,
            );

            final snackBar = SnackBar(
              content: MyBoldText(
                text: "Logged In",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => user.isProfileUpdated != true
                      ? UpdateProfile()
                      : user.isPreferenceUpdated != true
                      ? InterestsScreen()
                      : BottomNav(),
                ),
                (Route<dynamic> route) => false,
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

    ref.listen(googleAuthNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            await PrefsHelper.saveUserAuth(
              token: user.token,
              email: user.email,
              userId: user.userId,
            );
            await PrefsHelper.saveStatus(
              isLoggedIn: true,
              isProfileUpdated: user.isProfileUpdated,
              isPrefUpdated: user.isPreferenceUpdated,
            );
            final snackBar = SnackBar(
              content: MyBoldText(
                text: "Logged In",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => user.isProfileUpdated != true
                      ? UpdateProfile()
                      : user.isPreferenceUpdated != true
                      ? InterestsScreen()
                      : BottomNav(),
                ),
                (Route<dynamic> route) => false,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: MyRegularText(
                                  text: 'forget password?',
                                  color: MyColors.textLightColor(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          MyButton(
                            text: 'Login',
                            isLoading: authState.isLoading,
                            onClick: () async {
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
                                isLoading:
                                    googleAuthState.isLoading || isLoading,
                                onClick: () async {
                                  setState(() => isLoading = true);
                                  await googleSignInManager.signIn();
                                },
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
            );
          },
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
