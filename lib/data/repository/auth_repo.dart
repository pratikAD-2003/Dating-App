import 'dart:convert';
import 'dart:io';

import 'package:dating_app/data/model/response/auth/login/login_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/get_user_details_res.dart'
    hide AgeRangePreference;
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/profile_req_model.dart';
import 'package:dating_app/data/model/response/auth/profile/update_interest_res_model.dart';
import 'package:dating_app/data/model/response/auth/profile/update_language_res_model.dart';
import 'package:dating_app/data/model/response/auth/signup/signup_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final ApiClient apiClient;
  AuthRepository(this.apiClient);

  Future<LoginResModel> login(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiConstants.login, data);
    return LoginResModel.fromJson(response);
  }

  Future<LoginResModel> googleAuth(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiConstants.googleAuth, data);
    return LoginResModel.fromJson(response);
  }

  Future<SignupResModelModel> signup(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiConstants.signup, data);
    return SignupResModelModel.fromJson(response);
  }

  Future<LoginResModel> verifyEmailSignup(Map<String, dynamic> data) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtpForSignup,
      data,
    );
    return LoginResModel.fromJson(response);
  }

  Future<ProfileResModel> updateProfile({
    required String userId,
    required String fullName,
    required String profession,
    required String dateOfBirth,
    required String gender,
    required String bio,
    File? profilePhotoFile,
  }) async {
    final Map<String, String> data = {
      "userId": userId,
      "fullName": fullName,
      "profession": profession,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "bio": bio,
      // Don't add "profilePhotoUrl" if file is null
    };

    final response = await apiClient.putMultipart(
      ApiConstants.updateProfile,
      data,
      profilePhotoFile, // will only send if not null
      "profilePhotoUrl", // backend field for the file
    );

    return ProfileResModel.fromJson(response);
  }

  Future<PreferenceResModel> updatePreference({
    required String userId,
    required List<String>? interests,
    required List<String>? languages,
    required double? distancePreference,
    required AgeRangePreference? ageRangePreference,
    required List<String>? genderPreference,
    required Map<String, dynamic>? location,
    required List<File>? images,
  }) async {
    final Map<String, dynamic> data = {
      "userId": userId,
      "interests": interests ?? [],
      "languages": languages ?? [],
      "distancePreference": distancePreference ?? 0,
      "ageRangePreference":
          ageRangePreference?.toJson() ??
          {"min": 18, "max": 50}, // send as object
      "genderPreference": genderPreference ?? [],
      "location": location ?? {},
    };

    final rawResponse = await apiClient.putMultipartMultiple(
      ApiConstants.updateUserPreferences,
      data,
      images,
      "images",
    );

    // 🧠 Log for debugging
    debugPrint("📩 Raw Preference Update Response: $rawResponse");

    try {
      dynamic jsonResponse = rawResponse;

      // ✅ Step 1: Decode if it's a string
      if (rawResponse is String) {
        try {
          jsonResponse = jsonDecode(rawResponse as String);
        } catch (_) {
          // Not JSON — wrap it in a map
          jsonResponse = {"message": rawResponse};
        }
      }

      // ✅ Step 2: Ensure it’s always a Map
      if (jsonResponse is Map<String, dynamic>) {
        return PreferenceResModel.fromJson(jsonResponse);
      } else {
        return PreferenceResModel(message: jsonResponse.toString());
      }
    } catch (e, st) {
      debugPrint("⚠️ PreferenceResModel parsing failed: $e");
      debugPrint("StackTrace: $st");
      return PreferenceResModel(message: "Parsing error: $e");
    }
  }

  Future<GetUserDetailResModel> getUserDetails(String userId) async {
    final response = await apiClient.get(
      "${ApiConstants.getUserDetails}/$userId",
    );
    return GetUserDetailResModel.fromJson(response);
  }

  Future<UpdateInterestResModel> updateInterests(
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.putRequest(
      ApiConstants.updateInterest,
      data,
    );
    return UpdateInterestResModel.fromJson(response);
  }

  Future<UpdateIanguageResModel> updateLanguage(
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.putRequest(
      ApiConstants.updateLanguage,
      data,
    );
    return UpdateIanguageResModel.fromJson(response);
  }
}
