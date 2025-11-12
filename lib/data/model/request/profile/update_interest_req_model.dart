class UpdateInterestReqModel {
  String? userId;
  List<String>? interests;

  UpdateInterestReqModel({this.userId, this.interests});

  UpdateInterestReqModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    interests = json['interests'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['interests'] = this.interests;
    return data;
  }
}
