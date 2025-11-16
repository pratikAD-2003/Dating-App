class SendMsgReqModel {
  String? chatId;
  String? senderId;
  String? text;

  SendMsgReqModel({this.chatId, this.senderId, this.text});

  SendMsgReqModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    senderId = json['senderId'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['senderId'] = this.senderId;
    data['text'] = this.text;
    return data;
  }
}
