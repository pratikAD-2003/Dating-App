class GetRequestedMatchUsersResModel {
  bool? success;
  int? count;
  List<Users>? users;

  GetRequestedMatchUsersResModel({this.success, this.count, this.users});

  GetRequestedMatchUsersResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];

    if (json['users'] != null) {
      users = (json['users'] as List)
          .map((e) => Users.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      users = [];
    }
  }
}

class Users {
  String? userId;
  String? fullName;
  String? profession;
  String? profilePhotoUrl;
  int? age;

  Users({
    this.userId,
    this.fullName,
    this.profession,
    this.profilePhotoUrl,
    this.age,
  });

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profession = json['profession'];
    profilePhotoUrl = json['profilePhotoUrl'];
    age = json['age'];
  }
}
