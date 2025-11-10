class ProfileResModel {
  String? message;
  Data? data;

  ProfileResModel({this.message, this.data});

  ProfileResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  int? iV;
  String? bio;
  String? createdAt;
  String? fullName;
  String? gender;
  String? profession;
  String? profilePhotoUrl;
  String? updatedAt;
  String? dateOfBirth;

  Data(
      {this.sId,
      this.userId,
      this.iV,
      this.bio,
      this.createdAt,
      this.fullName,
      this.gender,
      this.profession,
      this.profilePhotoUrl,
      this.updatedAt,
      this.dateOfBirth});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    bio = json['bio'];
    createdAt = json['createdAt'];
    fullName = json['fullName'];
    gender = json['gender'];
    profession = json['profession'];
    profilePhotoUrl = json['profilePhotoUrl'];
    updatedAt = json['updatedAt'];
    dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['bio'] = this.bio;
    data['createdAt'] = this.createdAt;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['profession'] = this.profession;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    data['updatedAt'] = this.updatedAt;
    data['dateOfBirth'] = this.dateOfBirth;
    return data;
  }
}
