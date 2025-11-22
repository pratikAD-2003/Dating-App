class ChangePassReqModel {
  String? email;
  String? oldPassword;
  String? newPassword;

  ChangePassReqModel({this.email, this.oldPassword, this.newPassword});

  ChangePassReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
