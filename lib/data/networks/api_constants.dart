class ApiConstants {
  // static const String baseUrl = "http://10.144.216.145:5235/";
  static const String baseUrl =
      "https://sparkmatch-dating-app-backend.onrender.com/";

  // LOGIN
  static const String login = "api/user/auth/login";

  // GOOGLE LOGIN/SIGNUP
  static const String googleAuth = "api/user/auth/googleAuth";

  // SIGNUP
  static const String signup = "api/user/auth/signup";
  static const String verifyOtpForSignup = "api/user/auth/verifyOtpForSignup";

  // RESET AND CHANGE PASSWORD
  static const String sendOtpForResetPassword =
      "api/user/auth/sendOtpForResetPassword";
  static const String verifyEmailForResetPassword =
      "api/user/auth/verifyEmailForResetPassword";
  static const String resetPassword = "api/user/auth/resetPassword";
  static const String changePassword = "api/user/auth/changePassword";

  // GET USER DETAILS
  static const String getUserDetails = "api/user/auth/getUserDetails";
  static const String updateLanguage = "api/user/auth/updateLanguages";
  static const String updateInterest = "api/user/auth/updateInterests";

  // PROFILE UPDATE
  static const String updateProfile = "api/user/auth/updateProfile";

  // PREFERENCE UPDATE
  static const String updateUserPreferences =
      "api/user/auth/updateUserPreferences";
  // PREFERENCE UPDATE AND REMOVE
  static const String updateRemovePreferences =
      "api/user/auth/updatePreferences";

  // USERS
  static const String getHomeMatches = "api/user/item/getHomeMatches";
  static const String handleInteraction = "api/user/item/handleInteraction";
  static const String getFavoriteUsers = "api/user/item/getFavoriteUsers";
  static const String getMatchedUsers = "api/user/item/getMatchedUsers";
  static const String getRequestedUsers = "api/user/item/getRequestedUsers";
  static const String SEND_MATCH_REQUEST = "requested";
  static const String MARK_SAVED = "favorite";

  // STORY
  static const String uploadStory = "api/user/stories/uploadStory";
  static const String viewStory = "api/user/stories/markStorySeen";
  static const String deleteStory = "api/user/stories/deleteStory";
  static const String getStories = "api/user/stories/getStories";
  static const String getUserStoriesById =
      "api/user/stories/getUserStoriesById";
  static const String getViewedStoryUsers =
      "api/user/stories/getViewedStoryUsers";

  // CHAT
  static const String getUserChats = "api/user/chat/getUserChats";
  static const String getChatUsers = "api/user/chat/list";
  static const String getUserMessages = "api/user/chat/messages";
  static const String markSeen = "api/user/chat/mark-seen";
  static const String sendMessage = "api/user/chat/send-message";
  static const String createChat = "api/user/chat/create-chat";
}
