import 'package:dating_app/data/model/response/user/get_home_users_res_model.dart';
import 'package:dating_app/data/model/response/user/get_requested_match_users_res_model.dart';
import 'package:dating_app/data/model/response/user/handle_interaction_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';

class UserRepository {
  final ApiClient apiClient;
  UserRepository(this.apiClient);

  Future<GetHomeUsersResModel?> getHomeMatches(String userId) async {
    final response = await apiClient.get(
      ApiConstants.getHomeMatches,
      params: {"userId": userId},
    );
    return GetHomeUsersResModel.fromJson(response);
  }

  Future<GetRequestedMatchUsersResModel?> getRequestedUsersMatches(
    String userId,
  ) async {
    final response = await apiClient.get(
      "${ApiConstants.getRequestedUsers}/$userId",
      params: {"type": "received"},
    );
    return GetRequestedMatchUsersResModel.fromJson(response);
  }

  Future<HandleInteractionResModel?> handleInteraction(
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.putRequest(
      ApiConstants.handleInteraction,
      data,
    );
    return HandleInteractionResModel.fromJson(response);
  }

  Future<GetRequestedMatchUsersResModel?> getFavoriteUsers(
    String userId,
  ) async {
    final response = await apiClient.get(
      "${ApiConstants.getFavoriteUsers}/$userId",
    );
    return GetRequestedMatchUsersResModel.fromJson(response);
  }

  Future<GetRequestedMatchUsersResModel?> getMatchedUsers(
    String userId,
  ) async {
    final response = await apiClient.get(
      "${ApiConstants.getMatchedUsers}/$userId",
    );
    return GetRequestedMatchUsersResModel.fromJson(response);
  }
}
