import 'dart:async';

import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/response/user/get_home_users_res_model.dart';
import 'package:dating_app/data/model/response/user/get_requested_match_users_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider((ref) => ApiClient());
final userRepoProvider = Provider(
  (ref) => UserRepository(ref.read(apiClientProvider)),
);

// GET HOME MATCHES---------------------------------------------------------------------------------------------------
class GetHomeMatches extends AsyncNotifier<GetHomeUsersResModel?> {
  late final UserRepository repo;

  @override
  FutureOr<GetHomeUsersResModel?> build() {
    // Initialize dependencies
    repo = ref.read(userRepoProvider);
    return null;
  }

  Future<void> getHomeMatches(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.getHomeMatches(userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_HOME_MATCHES_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_HOME_MATCHES_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getHomeMatchesProvider =
    AsyncNotifierProvider<GetHomeMatches, GetHomeUsersResModel?>(
      () => GetHomeMatches(),
    );

// GET REQUESTED MATCHES---------------------------------------------------------------------------------------------------
class GetRequestedMatches
    extends AsyncNotifier<GetRequestedMatchUsersResModel?> {
  late final UserRepository repo;

  @override
  FutureOr<GetRequestedMatchUsersResModel?> build() {
    // Initialize dependencies
    repo = ref.read(userRepoProvider);
    return null;
  }

  Future<void> getRequestedMathces(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.getRequestedUsersMatches(userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_REQUESTED_MATCHES_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_REQUESTED_MATCHES_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getRequestedMatchesProvider =
    AsyncNotifierProvider<GetRequestedMatches, GetRequestedMatchUsersResModel?>(
      () => GetRequestedMatches(),
    );
