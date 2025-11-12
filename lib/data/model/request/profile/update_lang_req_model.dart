class UpdateLanguageReqModel {
  String? userId;
  List<String>? languages;

  UpdateLanguageReqModel({this.userId, this.languages});

  UpdateLanguageReqModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    languages = json['languages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['languages'] = this.languages;
    return data;
  }
}
