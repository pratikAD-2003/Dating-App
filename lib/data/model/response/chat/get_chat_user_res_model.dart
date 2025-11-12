class GetChatUserResModel {
  bool? success;
  int? page;
  int? size;
  int? total;
  int? totalPages;
  List<Chats>? chats;

  GetChatUserResModel(
      {this.success,
      this.page,
      this.size,
      this.total,
      this.totalPages,
      this.chats});

  GetChatUserResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    page = json['page'];
    size = json['size'];
    total = json['total'];
    totalPages = json['totalPages'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(new Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['page'] = this.page;
    data['size'] = this.size;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? sId;
  String? updatedAt;
  String? chatId;
  Participant? participant;
  String? lastMessage;
  bool? byMe;
  bool? isSeenMessage;
  bool? isSeenStory;
  int? unseenMessagesCount;

  Chats(
      {this.sId,
      this.updatedAt,
      this.chatId,
      this.participant,
      this.lastMessage,
      this.byMe,
      this.isSeenMessage,
      this.isSeenStory,
      this.unseenMessagesCount});

  Chats.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    chatId = json['chatId'];
    participant = json['participant'] != null
        ? new Participant.fromJson(json['participant'])
        : null;
    lastMessage = json['lastMessage'];
    byMe = json['byMe'];
    isSeenMessage = json['isSeenMessage'];
    isSeenStory = json['isSeenStory'];
    unseenMessagesCount = json['unseenMessagesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['updatedAt'] = this.updatedAt;
    data['chatId'] = this.chatId;
    if (this.participant != null) {
      data['participant'] = this.participant!.toJson();
    }
    data['lastMessage'] = this.lastMessage;
    data['byMe'] = this.byMe;
    data['isSeenMessage'] = this.isSeenMessage;
    data['isSeenStory'] = this.isSeenStory;
    data['unseenMessagesCount'] = this.unseenMessagesCount;
    return data;
  }
}

class Participant {
  String? fullName;
  String? profilePhotoUrl;

  Participant({this.fullName, this.profilePhotoUrl});

  Participant.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    profilePhotoUrl = json['profilePhotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    return data;
  }
}
