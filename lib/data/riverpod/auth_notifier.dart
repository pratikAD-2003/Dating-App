import 'dart:io';

import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/response/auth/login/login_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/get_user_details_res.dart'
    hide AgeRangePreference;
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/profile_req_model.dart';
import 'package:dating_app/data/model/response/auth/profile/update_interest_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/update_language_res_model.dart';
import 'package:dating_app/data/model/response/auth/signup/signup_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/repository/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider((ref) => ApiClient());
final authRepoProvider = Provider(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

// 🔹 Login------------------------------------------------------------------------------------------------------------
class AuthNotifier extends AsyncNotifier<LoginResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<LoginResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  /// 🔹 Login method
  Future<void> login(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.login(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("LOGIN_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("LOGIN_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }

  /// 🔹 Logout or clear session
  void logout() {
    state = const AsyncValue.data(null);
  }
}

final loginNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, LoginResModel?>(() => AuthNotifier());

// 🔹 Login------------------------------------------------------------------------------------------------------------
class GoogleAuthNotifier extends AsyncNotifier<LoginResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<LoginResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  /// 🔹 Login method
  Future<void> googleAuth(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.googleAuth(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GOOGLE_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GOOGLE_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }

  /// 🔹 Logout or clear session
  void logout() {
    state = const AsyncValue.data(null);
  }
}

final googleAuthNotifierProvider =
    AsyncNotifierProvider<GoogleAuthNotifier, LoginResModel?>(
      () => GoogleAuthNotifier(),
    );

// 🔹 Signup------------------------------------------------------------------------------------------------------------
class SignupNotifier extends AsyncNotifier<SignupResModelModel?> {
  @override
  Future<SignupResModelModel?> build() async => null;

  Future<void> signup(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepoProvider);
    try {
      final res = await repo.signup(data);
      state = AsyncValue.data(res);
      debugPrint("SIGNUP_STATUS ---> API SUCCESS");
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("SIGNUP_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("SIGNUP_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final signupNotifierProvider =
    AsyncNotifierProvider<SignupNotifier, SignupResModelModel?>(
      () => SignupNotifier(),
    );

// 🔹 Verify Signup------------------------------------------------------------------------------------------------------------
class VerifyEmailSignup extends AsyncNotifier<LoginResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<LoginResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  /// 🔹 Login method
  Future<void> verifyEmailSignup(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.verifyEmailSignup(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("VERIFY_SIGNUP_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("VERIFY_SIGNUP_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final verifySignupEmailNotifierProvider =
    AsyncNotifierProvider<VerifyEmailSignup, LoginResModel?>(
      () => VerifyEmailSignup(),
    );

// 🔹 Profile Update------------------------------------------------------------------------------------------------------------
class ProfileNotifier extends AsyncNotifier<ProfileResModel?> {
  late final AuthRepository _profileRepository;

  @override
  Future<ProfileResModel?> build() async {
    _profileRepository = ref.read(authRepoProvider);
    return null;
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String profession,
    required String dateOfBirth,
    required String gender,
    required String bio,
    File? profilePhotoFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _profileRepository.updateProfile(
        userId: userId,
        fullName: fullName,
        profession: profession,
        dateOfBirth: dateOfBirth,
        gender: gender,
        bio: bio,
        profilePhotoFile: profilePhotoFile,
      );
      state = AsyncValue.data(res);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("PROFILE_UPDATE_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      state = AsyncValue.error("Unexpected Error: $e", st);
      debugPrint("PROFILE_UPDATE_STATUS ---> API ERROR - $e");
    }
  }
}

final updateProfileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileResModel?>(
      () => ProfileNotifier(),
    );

// 🔹 Preference Update------------------------------------------------------------------------------------------------------------
class PreferenceNotifier extends AsyncNotifier<PreferenceResModel?> {
  late final AuthRepository _profileRepository;

  @override
  Future<PreferenceResModel?> build() async {
    _profileRepository = ref.read(authRepoProvider);
    return null;
  }

  Future<void> updatePref({
    required String userId,
    required List<String>? interests,
    required List<String>? languages,
    required double? distancePreference,
    required AgeRangePreference? ageRangePreference,
    required List<String>? genderPreference,
    required Map<String, dynamic>? location,
    required List<File>? images,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _profileRepository.updatePreference(
        userId: userId,
        interests: interests,
        languages: languages,
        distancePreference: distancePreference,
        ageRangePreference: ageRangePreference,
        genderPreference: genderPreference,
        location: location,
        images: images,
      );
      state = AsyncValue.data(res);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("PREFERENCE_UPDATE_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      state = AsyncValue.error("Unexpected Error: $e", st);
      debugPrint("PREFERENCE_UPDATE_STATUS ---> API ERROR - $e");
    }
  }
}

final updatePreferenceNotifierProvider =
    AsyncNotifierProvider<PreferenceNotifier, PreferenceResModel?>(
      () => PreferenceNotifier(),
    );

// 🔹 User Details------------------------------------------------------------------------------------------------------------
class GetUserDetailsNotifier extends AsyncNotifier<GetUserDetailResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<GetUserDetailResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  /// 🔹 Login method
  Future<void> getUserDetails(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.getUserDetails(userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_USER_DETAILS_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_USER_DETAILS_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getUserDetailsNotifierProvider =
    AsyncNotifierProvider<GetUserDetailsNotifier, GetUserDetailResModel?>(
      () => GetUserDetailsNotifier(),
    );

// 🔹 Update Language------------------------------------------------------------------------------------------------------------
class UpdateLanguageNotifier extends AsyncNotifier<UpdateIanguageResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<UpdateIanguageResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  Future<void> updateLanguage(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.updateLanguage(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("UPDATE_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("UPDATE_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final updateLanguageNotifierProvider =
    AsyncNotifierProvider<UpdateLanguageNotifier, UpdateIanguageResModel?>(
      () => UpdateLanguageNotifier(),
    );


// 🔹 Update Interest------------------------------------------------------------------------------------------------------------
class UpdateInterestNotifier extends AsyncNotifier<UpdateInterestResModel?> {
  late final AuthRepository _authRepository;

  @override
  Future<UpdateInterestResModel?> build() async {
    // Initialize dependencies
    _authRepository = ref.read(authRepoProvider);
    return null;
  }

  Future<void> updateInterest(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.updateInterests(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("UPDATE_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("UPDATE_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final updateInterestNotifierProvider =
    AsyncNotifierProvider<UpdateInterestNotifier, UpdateInterestResModel?>(
      () => UpdateInterestNotifier(),
    );
