class SendMsgResModel {
  String? chatId;
  String? senderId;
  String? text;
  List<String>? seenBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SendMsgResModel({
    this.chatId,
    this.senderId,
    this.text,
    this.seenBy,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory SendMsgResModel.fromJson(Map<String, dynamic> json) {
    return SendMsgResModel(
      chatId: json['chatId'],
      senderId: json['senderId'],
      text: json['text'],
      seenBy: json['seenBy'] != null ? List<String>.from(json['seenBy']) : [],
      sId: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'seenBy': seenBy ?? [],
      '_id': sId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}
