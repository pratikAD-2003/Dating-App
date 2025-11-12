class UpdateIanguageResModel {
  String? message;
  List<String>? data;

  UpdateIanguageResModel({this.message, this.data});

  UpdateIanguageResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
