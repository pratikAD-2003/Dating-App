import 'package:dating_app/data/model/response/chat/chat_user_list_res_model.dart';
import 'package:dating_app/data/model/response/chat/create_chat_res_model.dart';
import 'package:dating_app/data/model/response/chat/mark_seen_sucess_res_model.dart';
import 'package:dating_app/data/model/response/chat/msg_res_model.dart';
import 'package:dating_app/data/model/response/chat/send_msg_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/repository/chat_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Repository provider
final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ApiClient()),
);

// ================================
// Load Chat Users
// ================================
class ChatNotifier
    extends StateNotifier<AsyncValue<List<ChatUserListResModel>>> {
  final ChatRepository repo;
  final String currentUserId;
  IO.Socket? socket;

  ChatNotifier(this.repo, this.currentUserId)
    : super(const AsyncValue.loading()) {
    loadChats();
    _setupSocket();
  }

  Future<void> loadChats() async {
    try {
      final users = await repo.getChatUsers(currentUserId);
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _setupSocket() {
    socket = repo.socket;

    if (!(socket!.connected)) {
      socket!.connect();
    }

    socket!.emit("joinUser", currentUserId);

    // When new chat message comes → refresh chat users list
    socket!.on("new-message", (data) {
      loadChats();
    });

    // when unseen/seen update → refresh chat list
    socket!.on("seen-update", (data) {
      loadChats();
    });

    // For typing indicator
    socket!.on("typing-status", (data) {
      loadChats();
    });
  }
}

final chatListNotifierProvider =
    StateNotifierProvider.family<
      ChatNotifier,
      AsyncValue<List<ChatUserListResModel>>,
      String
    >((ref, userId) => ChatNotifier(ref.read(chatRepositoryProvider), userId));

// ================================
// Load Messages
// ================================
class GetMessagesNotifier
    extends StateNotifier<AsyncValue<List<MessageModelResModel>>> {
  final ChatRepository repo;
  final String chatId;
  IO.Socket? socket;

  GetMessagesNotifier(this.repo, this.chatId)
    : super(const AsyncValue.loading()) {
    loadMessages();
    _setupSocket();
  }

  // ================================
  // Load Messages
  // ================================
  Future<void> loadMessages() async {
    try {
      final msgs = await repo.getUserMessages(chatId);
      state = AsyncValue.data(msgs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ================================
  // Setup Socket Listeners
  // ================================
  void _setupSocket() {
    socket = repo.socket;

    if (!(socket!.connected)) {
      socket!.connect();
    }

    // Join chat room
    socket!.emit("joinChat", {"chatId": chatId});

    // ---------------------------------
    // NEW MESSAGE EVENT
    // ---------------------------------
    socket!.on("new-message", (data) {
      final message = data["message"];

      // Check if message belongs to the same chatId
      if (message["chatId"] == chatId) {
        loadMessages(); // refresh only this chat's messages
      }
    });

    // ---------------------------------
    // Seen Updates
    // ---------------------------------
    socket!.on("seen-update", (data) {
      if (data["chatId"] == chatId) {
        loadMessages();
      }
    });

    // ---------------------------------
    // Typing event → DO NOT REFRESH messages
    // ---------------------------------
    socket!.on("typing-status", (data) {
      // handled in ChatNotifier, not message list
    });
  }
}

final messageListNotifierProvider =
    StateNotifierProvider.family<
      GetMessagesNotifier,
      AsyncValue<List<MessageModelResModel>>,
      String
    >(
      (ref, chatId) =>
          GetMessagesNotifier(ref.read(chatRepositoryProvider), chatId),
    );

// ================================
// MarkSeenNotifier
// ================================
class MarkSeenNotifier
    extends StateNotifier<AsyncValue<MarkSeenSuccessResModel?>> {
  final ChatRepository repo;
  final String userId;
  final String chatId;

  MarkSeenNotifier(this.repo, this.userId, this.chatId)
    : super(const AsyncValue.data(null));

  void markSeen() {
    if (userId.isEmpty || chatId.isEmpty) return;

    repo
        .markSeenMessage(userId, chatId)
        .then((res) {
          state = AsyncValue.data(res);
        })
        .catchError((e) {
          // ignore errors
        });
  }
}

final markSeenNotifierProvider =
    StateNotifierProvider.family<
      MarkSeenNotifier,
      AsyncValue<MarkSeenSuccessResModel?>,
      Map<String, String>
    >(
      (ref, params) => MarkSeenNotifier(
        ref.read(chatRepositoryProvider),
        params["userId"]!,
        params["chatId"]!,
      ),
    );

class SendMsgNotifier extends StateNotifier<AsyncValue<SendMsgResModel?>> {
  final ChatRepository repo;
  final String userId;
  final String chatId;

  SendMsgNotifier(this.repo, this.userId, this.chatId)
    : super(const AsyncValue.data(null));

  /// Fire-and-forget send message
  void sendMessage(String text) {
    if (text.isEmpty) return;

    repo
        .sendMsg(userId, chatId, text)
        .then((res) {
          // Optional: update state if needed
          state = AsyncValue.data(res);
        })
        .catchError((e) {
          // ignore errors
        });
  }
}

final sendMsgNotifierProvider =
    StateNotifierProvider.family<
      SendMsgNotifier,
      AsyncValue<SendMsgResModel?>,
      Map<String, String>
    >(
      (ref, params) => SendMsgNotifier(
        ref.read(chatRepositoryProvider),
        params["userId"]!,
        params["chatId"]!,
      ),
    );

// ================================
// CreateChatNotifier
// ================================
class CreateChatNotifier
    extends StateNotifier<AsyncValue<CreateChatResModel?>> {
  final ChatRepository repo;
  final String senderId;
  final String receiverId;

  CreateChatNotifier(this.repo, this.senderId, this.receiverId)
    : super(const AsyncValue.data(null));

  void createChat() {
    if (senderId.isEmpty || receiverId.isEmpty) return;

    repo
        .createChat(senderId, receiverId)
        .then((res) {
          state = AsyncValue.data(res);
        })
        .catchError((e) {
          // ignore errors
        });
  }
}

final createChatNotifierProvider =
    StateNotifierProvider.family<
      CreateChatNotifier,
      AsyncValue<CreateChatResModel?>,
      Map<String, String>
    >(
      (ref, params) => CreateChatNotifier(
        ref.read(chatRepositoryProvider),
        params["senderId"]!,
        params["receiverId"]!,
      ),
    );
