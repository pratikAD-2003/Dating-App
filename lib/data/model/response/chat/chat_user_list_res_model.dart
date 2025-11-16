class ChatUserListResModel {
  String? chatId;
  String? userId;
  String? fullName;
  String? profilePhotoUrl;
  LastMessage? lastMessage;
  int? unseenCount;
  bool? typing;
  String? updatedAt;

  ChatUserListResModel(
      {this.chatId,
      this.userId,
      this.fullName,
      this.profilePhotoUrl,
      this.lastMessage,
      this.unseenCount,
      this.typing,
      this.updatedAt});

  ChatUserListResModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    userId = json['userId'];
    fullName = json['fullName'];
    profilePhotoUrl = json['profilePhotoUrl'];
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    unseenCount = json['unseenCount'];
    typing = json['typing'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    data['unseenCount'] = this.unseenCount;
    data['typing'] = this.typing;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class LastMessage {
  String? message;
  String? senderId;
  String? createdAt;

  LastMessage({this.message, this.senderId, this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderId = json['senderId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['senderId'] = this.senderId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
