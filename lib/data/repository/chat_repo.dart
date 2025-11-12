// chat_repository.dart
import 'package:dating_app/data/model/request/chat/get_chat_user_res_model.dart';
import 'package:dating_app/data/model/response/chat/get_chat_user_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';

class ChatRepository {
  final ApiClient apiClient;
  ChatRepository(this.apiClient);

  Future<GetChatUserResModel> getUserChats({
    required String userId,
    required GetChatUserReqModel body,
  }) async {
    final response = await apiClient.post(
      "${ApiConstants.getUserChats}/$userId",
      body.toJson(),
    );

    return GetChatUserResModel.fromJson(response);
  }
}
