class GetHomeUsersResModel {
  bool? success;
  int? count;
  List<Users>? users;

  GetHomeUsersResModel({this.success, this.count, this.users});

  GetHomeUsersResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? userId;
  String? fullName;
  String? profession;
  String? profilePhotoUrl;
  int? age;
  num? distance;

  Users({
    this.userId,
    this.fullName,
    this.profession,
    this.profilePhotoUrl,
    this.age,
    this.distance,
  });

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    profession = json['profession'];
    profilePhotoUrl = json['profilePhotoUrl'];
    age = json['age'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profession'] = this.profession;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    data['age'] = this.age;
    data['distance'] = this.distance;
    return data;
  }
}
