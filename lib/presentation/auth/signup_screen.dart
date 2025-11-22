import 'package:dating_app/data/local/google_signing_manager.dart';
import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/google_auth_req_model.dart';
import 'package:dating_app/data/model/request/auth/login/login_req_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/presentation/auth/login_screen.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/auth/verify_otp.dart';
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

  late GoogleSignInManager googleSignInManager;
  bool isLoading = false;

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
    final authState = ref.watch(signupNotifierProvider);
    final googleAuthState = ref.watch(googleAuthNotifierProvider);

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyOtp(
                    email: emailController.text,
                    password: confirmPassController.text,
                  ),
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
                text: user.message ?? "Signned in successfully.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) {
              // ✅ Navigate only after snackbar disappears
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
                            onClick: () async {
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
                                isLoading:
                                    googleAuthState.isLoading || isLoading,
                                icon: 'assets/images/google.png',
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
            );
          },
        ),
      ),
    );
  }
}
