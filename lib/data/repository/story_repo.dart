import 'dart:io';

import 'package:dating_app/data/model/response/socket/story/story_model.dart';
import 'package:dating_app/data/model/response/story/get_user_stories_res_model.dart';
import 'package:dating_app/data/networks/api_client.dart';
import 'package:dating_app/data/networks/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StoryRepository {
  final ApiClient apiClient;
  late IO.Socket socket;

  StoryRepository(this.apiClient) {
    // Connect to your backend socket
    socket = IO.io("http://localhost:5235", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();
  }

  Future<List<StoryModel>> getStories(String userId) async {
    final res = await apiClient.get("${ApiConstants.getStories}/$userId");
    if (res['success']) {
      return (res['stories'] as List)
          .map((e) => StoryModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<StoryModel?> uploadStory(String userId, File file) async {
    final res = await apiClient.putMultipart(
      "/stories/uploadStory",
      {"userId": userId},
      file,
      "storyImageUrl",
    );
    if (res['success']) return StoryModel.fromJson(res['story']);
    return null;
  }

  Future<StoryModel> markStorySeen(String storyId, String userId) async {
    final response = await apiClient.post(ApiConstants.viewStory, {
      'storyId': storyId,
      'userId': userId,
    });

    // The backend returns `story` object
    return StoryModel.fromJson(response['story']);
  }

  // Realtime: Listen for new stories
  void onNewStory(void Function(StoryModel story) callback) {
    socket.on("newStory", (data) {
      callback(StoryModel.fromJson(data));
    });
  }

  // Realtime: Listen for story seen updates
  void onStorySeen(void Function(String storyId, String userId) callback) {
    socket.on("storySeen", (data) {
      callback(data['storyId'], data['userId']);
    });
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
