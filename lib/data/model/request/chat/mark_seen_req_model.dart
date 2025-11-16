class MarkSeenReqModel {
  String? userId;
  String? chatId;

  MarkSeenReqModel({this.userId, this.chatId});

  MarkSeenReqModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['chatId'] = this.chatId;
    return data;
  }
}
