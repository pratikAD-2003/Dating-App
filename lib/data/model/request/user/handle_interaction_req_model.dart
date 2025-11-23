class HandleInteractionReqModel {
  String? fromUser;
  String? toUser;
  String? status;

  HandleInteractionReqModel({this.fromUser, this.toUser, this.status});

  HandleInteractionReqModel.fromJson(Map<String, dynamic> json) {
    fromUser = json['fromUser'];
    toUser = json['toUser'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromUser'] = this.fromUser;
    data['toUser'] = this.toUser;
    data['status'] = this.status;
    return data;
  }
}
