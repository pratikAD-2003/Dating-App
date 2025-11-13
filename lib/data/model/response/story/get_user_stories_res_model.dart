class GetUserStoriesResModel {
  bool? success;
  User? user;

  GetUserStoriesResModel({this.success, this.user});

  GetUserStoriesResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? fullName;
  String? profilePhotoUrl;
  List<Stories>? stories;

  User({this.userId, this.fullName, this.profilePhotoUrl, this.stories});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoUrl = json['profilePhotoUrl'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  String? storyId;
  String? mediaUrl;
  String? createdAt;

  Stories({this.storyId, this.mediaUrl, this.createdAt});

  Stories.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    mediaUrl = json['mediaUrl'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storyId'] = this.storyId;
    data['mediaUrl'] = this.mediaUrl;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
