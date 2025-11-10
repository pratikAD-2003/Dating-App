class LoginResModel {
  String? message;
  String? token;
  String? email;
  String? userId;

  LoginResModel({this.message, this.token, this.email, this.userId});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    email = json['email'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['email'] = this.email;
    data['userId'] = this.userId;
    return data;
  }
}
