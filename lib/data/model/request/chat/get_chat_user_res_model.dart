class GetChatUserReqModel {
  int? page;
  int? size;
  String? search;

  GetChatUserReqModel({this.page, this.size, this.search});

  GetChatUserReqModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['size'] = this.size;
    data['search'] = this.search;
    return data;
  }
}
