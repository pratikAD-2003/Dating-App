class UpdateRemoveUserPreferenceResModel {
  String? message;
  Data? data;

  UpdateRemoveUserPreferenceResModel({this.message, this.data});

  UpdateRemoveUserPreferenceResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  AgeRangePreference? ageRangePreference;
  Location? location;
  String? sId;
  String? userId;
  int? iV;
  String? createdAt;
  int? distancePreference;
  List<String>? gallery;
  List<String>? genderPreference;
  List<String>? interests;
  List<String>? languages;
  String? updatedAt;

  Data(
      {this.ageRangePreference,
      this.location,
      this.sId,
      this.userId,
      this.iV,
      this.createdAt,
      this.distancePreference,
      this.gallery,
      this.genderPreference,
      this.interests,
      this.languages,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    ageRangePreference = json['ageRangePreference'] != null
        ? new AgeRangePreference.fromJson(json['ageRangePreference'])
        : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    distancePreference = json['distancePreference'];
    gallery = json['gallery'].cast<String>();
    genderPreference = json['genderPreference'].cast<String>();
    interests = json['interests'].cast<String>();
    languages = json['languages'].cast<String>();
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ageRangePreference != null) {
      data['ageRangePreference'] = this.ageRangePreference!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['distancePreference'] = this.distancePreference;
    data['gallery'] = this.gallery;
    data['genderPreference'] = this.genderPreference;
    data['interests'] = this.interests;
    data['languages'] = this.languages;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class AgeRangePreference {
  int? max;
  int? min;

  AgeRangePreference({this.max, this.min});

  AgeRangePreference.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max'] = this.max;
    data['min'] = this.min;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;
  String? city;
  String? country;

  Location({this.type, this.coordinates, this.city, this.country});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    city = json['city'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['city'] = this.city;
    data['country'] = this.country;
    return data;
  }
}
