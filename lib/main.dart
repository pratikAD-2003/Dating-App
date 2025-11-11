import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/presentation/auth/onboarding_screen.dart';
import 'package:dating_app/presentation/bottom_nav/bottom_nav.dart';
import 'package:dating_app/presentation/profile/interest_screen.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/theme.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_search/mapbox_search.dart';

void main() {
  MapBoxSearch.init(Utils.mapbox);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final isLoggedIn = await PrefsHelper.getIsLoggedIn() ?? false;
    final isProfileUpdated = await PrefsHelper.getIsProfileUpdated() ?? false;
    final isPrefUpdated = await PrefsHelper.getIsPrefUpdated() ?? false;

    if (!isLoggedIn) {
      return const OnboardingScreen(); // user not logged in
    } else if (!isProfileUpdated) {
      return const UpdateProfile(); // logged in but profile incomplete
    } else if (!isPrefUpdated) {
      return const InterestsScreen(); // profile done but preferences incomplete
    } else {
      return const BottomNav(); // everything done, navigate to home
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SparkMatch',
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show splash/loading screen while checking
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Error handling
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          } else {
            // Navigate to the determined screen
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
