class GetStoryUsersResModel {
  bool? success;
  int? count;
  int? total;
  int? currentPage;
  int? totalPages;
  List<Stories>? stories;

  GetStoryUsersResModel(
      {this.success,
      this.count,
      this.total,
      this.currentPage,
      this.totalPages,
      this.stories});

  GetStoryUsersResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    total = json['total'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    data['total'] = this.total;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  String? storyId;
  String? userId;
  String? fullName;
  String? profilePhotoUrl;
  bool? isSeen;

  Stories(
      {this.storyId,
      this.userId,
      this.fullName,
      this.profilePhotoUrl,
      this.isSeen});

  Stories.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoUrl = json['profilePhotoUrl'];
    isSeen = json['isSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storyId'] = this.storyId;
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    data['isSeen'] = this.isSeen;
    return data;
  }
}
