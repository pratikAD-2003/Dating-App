class MarkSeenSuccessResModel {
  bool? success;
  int? unreadCount;

  MarkSeenSuccessResModel({this.success, this.unreadCount});

  MarkSeenSuccessResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
