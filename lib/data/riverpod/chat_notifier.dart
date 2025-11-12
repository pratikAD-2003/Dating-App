import 'package:dating_app/data/model/api_exception_model.dart';
import 'package:dating_app/data/model/request/chat/get_chat_user_res_model.dart';
import 'package:dating_app/data/model/response/chat/get_chat_user_res_model.dart';
import 'package:dating_app/data/repository/chat_repo.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// providers.dart or repository_provider.dart
final chatRepoProvider = Provider(
  (ref) => ChatRepository(ref.read(apiClientProvider)),
);

class ChatNotifier extends AsyncNotifier<List<Chats>> {
  late final ChatRepository _chatRepository;

  int _page = 1;
  final int _size = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String? _search;

  @override
  Future<List<Chats>> build() async {
    _chatRepository = ref.read(chatRepoProvider);
    return [];
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchChats(String userId, {String? search}) async {
    // Prevent parallel or unnecessary calls
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final body = GetChatUserReqModel(
        page: _page,
        size: _size,
        search: search ?? _search,
      );
      final response = await _chatRepository.getUserChats(
        userId: userId,
        body: body,
      );

      final newChats = response.chats ?? [];

      // Append to existing list
      final currentChats = state.value ?? [];
      final updatedList = [...currentChats, ...newChats];

      // Update pagination flags
      if (newChats.isEmpty || _page >= (response.totalPages ?? 1)) {
        _hasMore = false;
      } else {
        _page++;
      }

      state = AsyncValue.data(updatedList);
    } on ApiExceptionModel catch (apiError) {
      // Caught API model (e.g. {"message": "Incorrect password!"})
      final message = apiError.message ?? "Something went wrong";
      state = AsyncValue.error(message, StackTrace.current);
      debugPrint("Get_CHAT_USER_STATUS ---> API ERROR - $message");
    } catch (e, st) {
      // Other unexpected errors
      state = AsyncValue.error("Unexpected error: $e", st);
      debugPrint("Get_CHAT_USER_STATUS ---> UNKNOWN ERROR - ($e)");
    }
  }

  void resetPagination() {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncValue.data([]);
  }
}

final chatNotifierProvider = AsyncNotifierProvider<ChatNotifier, List<Chats>>(
  () => ChatNotifier(),
);
