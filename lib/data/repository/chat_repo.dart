// chat_repository.dart
import 'package:dating_app/data/model/request/chat/create_chat_req_model.dart';
import 'package:dating_app/data/model/request/chat/mark_seen_req_model.dart';
import 'package:dating_app/data/model/request/chat/send_msg_req_model.dart';
import 'package:dating_app/data/model/response/chat/chat_user_list_res_model.dart';
import 'package:dating_app/data/model/response/chat/create_chat_res_model.dart';
import 'package:dating_app/data/model/response/chat/mark_seen_sucess_res_model.dart';
import 'package:dating_app/data/model/response/chat/msg_res_model.dart';
import 'package:dating_app/data/model/response/chat/send_msg_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRepository {
  final ApiClient apiClient;
  late IO.Socket socket;

  ChatRepository(this.apiClient) {
    socket = IO.io("http://localhost:5235", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
  }

  Future<List<ChatUserListResModel>> getChatUsers(String userId) async {
    final res = await apiClient.get("${ApiConstants.getChatUsers}/$userId");

    // 🔥 res is directly a List (no "data")
    if (res is List) {
      return res.map((e) => ChatUserListResModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<List<MessageModelResModel>> getUserMessages(String chatId) async {
    final res = await apiClient.get("${ApiConstants.getUserMessages}/$chatId");

    // 🔥 res is directly a List (no "data")
    if (res is List) {
      return res.map((e) => MessageModelResModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<MarkSeenSuccessResModel> markSeenMessage(
    String userId,
    String chatId,
  ) async {
    final res = await apiClient.post(
      ApiConstants.markSeen,
      MarkSeenReqModel(userId: userId, chatId: chatId).toJson(),
    );
    return res;
  }

  Future<SendMsgResModel> sendMsg(
    String userId,
    String chatId,
    String text,
  ) async {
    final res = await apiClient.post(
      ApiConstants.sendMessage,
      SendMsgReqModel(chatId: chatId, senderId: userId, text: text).toJson(),
    );
    return res;
  }

  Future<CreateChatResModel> createChat(
    String senderId,
    String receiverId,
  ) async {
    final res = await apiClient.post(
      ApiConstants.createChat,
      CreateChatReqModel(senderId: senderId, receiverId: receiverId).toJson(),
    );
    return res;
  }
}
