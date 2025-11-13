import 'package:dating_app/data/model/response/story/get_story_user_res_model.dart';
import 'package:dating_app/data/model/response/story/get_user_stories_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';

class StoryRepository {
  final ApiClient apiClient;
  StoryRepository(this.apiClient);

  Future<GetStoryUsersResModel> getStoryUsers({
    required String userId,
    required int page,
    int limit = 10,
  }) async {
    final response = await apiClient.get(
      ApiConstants.getStories,
      params: {
        "userId": userId,
        "page": page.toString(),
        "limit": limit.toString(),
      },
    );

    return GetStoryUsersResModel.fromJson(response);
  }

  Future<GetUserStoriesResModel> getUserStories({
    required String userId,
  }) async {
    final response = await apiClient.get(
      ApiConstants.getUserStoriesById,
      params: {"userId": userId},
    );

    return GetUserStoriesResModel.fromJson(response);
  }
}
