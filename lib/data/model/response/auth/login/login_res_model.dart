class LoginResModel {
  String? message;
  String? token;
  String? email;
  String? userId;
  bool? isProfileUpdated;
  bool? isPreferenceUpdated;

  LoginResModel({this.message, this.token, this.email, this.userId,this.isPreferenceUpdated,this.isProfileUpdated});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    email = json['email'];
    userId = json['userId'];
    isProfileUpdated = json['isProfileUpdated'];
    isPreferenceUpdated = json['isPreferenceUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['email'] = this.email;
    data['userId'] = this.userId;
    data['isProfileUpdated'] = this.isProfileUpdated;
    data['isPreferenceUpdated'] = this.isPreferenceUpdated;
    return data;
  }
}
