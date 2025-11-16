class MessageModelResModel {
  String? sId;
  String? chatId;
  String? senderId;
  String? text;
  List<String>? seenBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageModelResModel({
    this.sId,
    this.chatId,
    this.senderId,
    this.text,
    this.seenBy,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  MessageModelResModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatId = json['chatId'];
    senderId = json['senderId'];
    text = json['text'];
    seenBy = json['seenBy'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['chatId'] = this.chatId;
    data['senderId'] = this.senderId;
    data['text'] = this.text;
    data['seenBy'] = this.seenBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
