import 'package:dating_app/data/model/response/user/get_home_users_res_model.dart';
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
}
