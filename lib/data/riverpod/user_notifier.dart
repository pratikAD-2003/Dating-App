import 'dart:async';

import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/response/user/get_home_users_res_model.dart';
import 'package:dating_app/data/model/response/user/get_requested_match_users_res_model.dart';
import 'package:dating_app/data/model/response/user/handle_interaction_res_model.dart';
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

// GET FAVORITE MATCHES---------------------------------------------------------------------------------------------------
class GetFavoriteMatches
    extends AsyncNotifier<GetRequestedMatchUsersResModel?> {
  late final UserRepository repo;

  @override
  FutureOr<GetRequestedMatchUsersResModel?> build() {
    // Initialize dependencies
    repo = ref.read(userRepoProvider);
    return null;
  }

  Future<void> getFavoriteUsers(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.getFavoriteUsers(userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_FAVORITE_MATCHES_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_FAVORITE_MATCHES_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getFavoriteMatchesProvider =
    AsyncNotifierProvider<GetFavoriteMatches, GetRequestedMatchUsersResModel?>(
      () => GetFavoriteMatches(),
    );

// GET MATCHED UERS---------------------------------------------------------------------------------------------------
class GetMatchedUsers extends AsyncNotifier<GetRequestedMatchUsersResModel?> {
  late final UserRepository repo;

  @override
  FutureOr<GetRequestedMatchUsersResModel?> build() {
    // Initialize dependencies
    repo = ref.read(userRepoProvider);
    return null;
  }

  Future<void> getMatchedUsers(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.getMatchedUsers(userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_MATCHED_USERS_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_MATCHED_USERS_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getMatchedUsersProvider =
    AsyncNotifierProvider<GetMatchedUsers, GetRequestedMatchUsersResModel?>(
      () => GetMatchedUsers(),
    );

// POST INTERACTION---------------------------------------------------------------------------------------------------
class HandleInteration extends AsyncNotifier<HandleInteractionResModel?> {
  late final UserRepository repo;

  @override
  FutureOr<HandleInteractionResModel?> build() {
    // Initialize dependencies
    repo = ref.read(userRepoProvider);
    return null;
  }

  Future<void> handleInteration(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await repo.handleInteraction(data);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("HANDLE_INTERACTION_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("HANDLE_INTERACTION_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final handleInteractionProvider =
    AsyncNotifierProvider<HandleInteration, HandleInteractionResModel?>(
      () => HandleInteration(),
    );
