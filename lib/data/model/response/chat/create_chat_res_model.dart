class CreateChatResModel {
  String? senderId;
  String? receiverId;
  UnseenCount? unseenCount;
  TypingStatus? typingStatus;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CreateChatResModel(
      {this.senderId,
      this.receiverId,
      this.unseenCount,
      this.typingStatus,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CreateChatResModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    unseenCount = json['unseenCount'] != null
        ? new UnseenCount.fromJson(json['unseenCount'])
        : null;
    typingStatus = json['typingStatus'] != null
        ? new TypingStatus.fromJson(json['typingStatus'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    if (this.unseenCount != null) {
      data['unseenCount'] = this.unseenCount!.toJson();
    }
    if (this.typingStatus != null) {
      data['typingStatus'] = this.typingStatus!.toJson();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UnseenCount {
  int? i69200781aba82858061aa7e5;
  int? i6920089eaba82858061aa802;

  UnseenCount({this.i69200781aba82858061aa7e5, this.i6920089eaba82858061aa802});

  UnseenCount.fromJson(Map<String, dynamic> json) {
    i69200781aba82858061aa7e5 = json['69200781aba82858061aa7e5'];
    i6920089eaba82858061aa802 = json['6920089eaba82858061aa802'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['69200781aba82858061aa7e5'] = this.i69200781aba82858061aa7e5;
    data['6920089eaba82858061aa802'] = this.i6920089eaba82858061aa802;
    return data;
  }
}

class TypingStatus {
  bool? b69200781aba82858061aa7e5;
  bool? b6920089eaba82858061aa802;

  TypingStatus(
      {this.b69200781aba82858061aa7e5, this.b6920089eaba82858061aa802});

  TypingStatus.fromJson(Map<String, dynamic> json) {
    b69200781aba82858061aa7e5 = json['69200781aba82858061aa7e5'];
    b6920089eaba82858061aa802 = json['6920089eaba82858061aa802'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['69200781aba82858061aa7e5'] = this.b69200781aba82858061aa7e5;
    data['6920089eaba82858061aa802'] = this.b6920089eaba82858061aa802;
    return data;
  }
}
