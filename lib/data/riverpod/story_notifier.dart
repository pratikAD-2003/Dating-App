import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/response/socket/story/story_model.dart';
import 'package:dating_app/data/model/response/story/get_user_stories_res_model.dart'
    as userstories;
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/repository/story_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Repository provider
final storyRepositoryProvider = Provider<StoryRepository>(
  (ref) => StoryRepository(ApiClient()),
);

// Story Notifier
class StoryNotifier extends StateNotifier<AsyncValue<List<StoryModel>>> {
  final StoryRepository repo;
  final String currentUserId;
  IO.Socket? socket;

  StoryNotifier(this.repo, this.currentUserId)
    : super(const AsyncValue.loading()) {
    loadStories();
    _setupSocket();
  }

  /// Load initial stories from backend
  Future<void> loadStories() async {
    try {
      final stories = await repo.getStories(currentUserId);
      state = AsyncValue.data(stories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Setup socket for real-time story updates
  void _setupSocket() {
    socket ??= repo.socket;

    // New story from any user
    socket!.on('newStory', (data) {
      final story = StoryModel.fromJson(data);
      state = state.whenData((list) {
        if (story.userId == currentUserId) {
          return [story, ...list]; // own stories first
        } else {
          return [...list, story]; // others appended
        }
      });
    });

    // Story seen updates
    socket!.on('storySeen', (data) {
      final storyId = data['storyId'] as String?;
      final userId = data['userId'] as String?;
      if (storyId == null || userId == null) return;

      state = state.whenData((list) {
        return list.map((s) {
          if (s.storyId == storyId) {
            // mark as seen if the update is from current user
            return s.copyWith(
              isSeen: userId == currentUserId ? true : s.isSeen,
            );
          }
          return s;
        }).toList();
      });
    });
  }

  /// Mark story as seen
  Future<void> markSeen(String storyId) async {
    if (storyId.isEmpty) return;
    try {
      // Call backend to mark seen
      final updatedStory = await repo.markStorySeen(storyId, currentUserId);

      // Update state locally
      state = state.whenData((list) {
        return list.map((s) {
          if (s.storyId == updatedStory.storyId) {
            return s.copyWith(
              isSeen: true,
            ); // ✅ copyWith must return StoryModel
          }
          return s;
        }).toList();
      });
    } catch (e) {
      print("Error marking story seen: $e");
    }
  }
}

// Riverpod provider (Family allows passing userId)
final storyNotifierProvider =
    StateNotifierProvider.family<
      StoryNotifier,
      AsyncValue<List<StoryModel>>,
      String
    >(
      (ref, userId) => StoryNotifier(ref.read(storyRepositoryProvider), userId),
    );

// // Repository provider
// final storyRepositoryProvider = Provider<StoryRepository>(
//   (ref) => StoryRepository(ApiClient()),
// );

// // Story Notifier
// class StoryNotifier extends StateNotifier<AsyncValue<List<StoryModel>>> {
//   final StoryRepository repo;
//   final String currentUserId;
//   IO.Socket? socket;

//   StoryNotifier(this.repo, this.currentUserId) : super(const AsyncValue.loading()) {
//     loadStories();
//     _setupSocket();
//   }

//   /// Load initial stories
//   Future<void> loadStories() async {
//     try {
//       final stories = await repo.getStories(currentUserId);
//       state = AsyncValue.data(stories);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   /// Setup socket for realtime story updates
//   void _setupSocket() {
//     socket ??= repo.socket;

//     // New story from any user
//     socket!.on('newStory', (data) {
//       final story = StoryModel.fromJson(data);
//       state = state.whenData((list) {
//         // Own stories always first
//         if (story.userId == currentUserId) {
//           return [story, ...list];
//         } else {
//           // Append other users' stories
//           return [...list, story];
//         }
//       });
//     });

//     // Story seen updates
//     socket!.on('storySeen', (data) {
//       final storyId = data['storyId'] as String?;
//       final userId = data['userId'] as String?;

//       if (storyId == null || userId == null) return;

//       state = state.whenData((list) {
//         return list.map((s) {
//           if (s.storyId == storyId) {
//             return s.copyWith(isSeen: userId == currentUserId ? true : s.isSeen);
//           }
//           return s;
//         }).toList();
//       });
//     });
//   }

//   /// Mark story as seen
//   Future<void> markSeen(String storyId) async {
//     try {
//       await repo.markStorySeen(storyId, currentUserId);
//       state = state.whenData((list) {
//         return list.map((s) => s.storyId == storyId ? s.copyWith(isSeen: true) : s).toList();
//       });
//     } catch (_) {
//       // Handle error silently or log
//     }
//   }
// }

// // Riverpod provider (Family to pass userId)
// final storyNotifierProvider = StateNotifierProvider.family<StoryNotifier, AsyncValue<List<StoryModel>>, String>(
//   (ref, userId) => StoryNotifier(ref.read(storyRepositoryProvider), userId),
// );

// 🔹 Get User Stories------------------------------------------------------------------------------------------------------------
class GetUserStoriesNotifier
    extends AsyncNotifier<userstories.GetUserStoriesResModel?> {
  late final StoryRepository _storyRepository;

  @override
  Future<userstories.GetUserStoriesResModel?> build() async {
    // Initialize dependencies
    _storyRepository = ref.read(storyRepositoryProvider);
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
