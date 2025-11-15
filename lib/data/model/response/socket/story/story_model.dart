class StoryModel {
  final String storyId;
  final String userId;
  final String fullName;
  final String profilePhotoUrl;
  final String storyImageUrl;
  final bool isSeen;
  final DateTime createdAt;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.fullName,
    required this.profilePhotoUrl,
    required this.storyImageUrl,
    required this.isSeen,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['_id'] ?? json['storyId'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      storyImageUrl: json['storyImageUrl'] ?? '',
      isSeen: json['isSeen'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": storyId,
      "userId": userId,
      "fullName": fullName,
      "profilePhotoUrl": profilePhotoUrl,
      "storyImageUrl": storyImageUrl,
      "isSeen": isSeen,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  StoryModel copyWith({
    String? storyId,
    String? userId,
    String? fullName,
    String? profilePhotoUrl,
    String? storyImageUrl,
    bool? isSeen,
    DateTime? createdAt,
  }) {
    return StoryModel(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      storyImageUrl: storyImageUrl ?? this.storyImageUrl,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
