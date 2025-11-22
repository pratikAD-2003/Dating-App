class CreateChatReqModel {
  String? senderId;
  String? receiverId;

  CreateChatReqModel({this.senderId, this.receiverId});

  CreateChatReqModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    return data;
  }
}
