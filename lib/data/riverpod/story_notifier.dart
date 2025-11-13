import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/response/story/get_story_user_res_model.dart';
import 'package:dating_app/data/model/response/story/get_user_stories_res_model.dart'
    as userstories;
import 'package:dating_app/data/repository/story_repo.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final storyRepoProvider = Provider(
  (ref) => StoryRepository(ref.read(apiClientProvider)),
);

// Notifier
class StoryNotifier extends AsyncNotifier<List<Stories>> {
  late final StoryRepository _storyRepository;

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Stories>> build() async {
    _storyRepository = ref.read(storyRepoProvider);
    return [];
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchStories(String userId, {bool refresh = false}) async {
    if (_isLoadingMore || !_hasMore) return;

    if (refresh) {
      resetPagination();
    }

    _isLoadingMore = true;

    try {
      final response = await _storyRepository.getStoryUsers(
        userId: userId,
        page: _page,
        limit: _limit,
      );

      final newStories = response.stories ?? [];
      final currentStories = state.value ?? [];

      final updatedList = [...currentStories, ...newStories];

      // If less than limit => no more pages
      if (newStories.length < _limit) {
        _hasMore = false;
      } else {
        _page++;
      }
      state = AsyncValue.data(updatedList);
    } on ApiExceptionModel catch (apiError) {
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("Get_STORY_USER_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("Get_STORY_USER_STATUS ---> UNKNOWN ERROR - ($e)");
    } finally {
      _isLoadingMore = false;
    }
  }

  void resetPagination() {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncValue.data([]);
  }
}

// Provider
final storyNotifierProvider =
    AsyncNotifierProvider<StoryNotifier, List<Stories>>(() => StoryNotifier());

// 🔹 Get User Stories------------------------------------------------------------------------------------------------------------
class GetUserStoriesNotifier
    extends AsyncNotifier<userstories.GetUserStoriesResModel?> {
  late final StoryRepository _storyRepository;

  @override
  Future<userstories.GetUserStoriesResModel?> build() async {
    // Initialize dependencies
    _storyRepository = ref.read(storyRepoProvider);
    return null;
  }

  Future<void> getUserStories(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _storyRepository.getUserStories(userId: userId);
      state = AsyncValue.data(response);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("GET_USER_STORIES_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("GET_USER_STORIES_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }
}

final getUserStoriesNotifierProvider =
    AsyncNotifierProvider<
      GetUserStoriesNotifier,
      userstories.GetUserStoriesResModel?
    >(() => GetUserStoriesNotifier());
