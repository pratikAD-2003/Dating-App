import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  // Keys
  static const _keyToken = "auth_token";
  static const _keyEmail = "auth_email";
  static const _keyUserId = "auth_userId";

  static const _keyAgeMin = "pref_age_min";
  static const _keyAgeMax = "pref_age_max";
  static const _keyLocationType = "pref_location_type";
  static const _keyLocationLat = "pref_location_lat";
  static const _keyLocationLng = "pref_location_lng";
  static const _keyLocationCity = "pref_location_city";
  static const _keyLocationCountry = "pref_location_country";
  static const _keyDistancePref = "pref_distance";
  static const _keyGallery = "pref_gallery";
  static const _keyGenderPref = "pref_gender";
  static const _keyInterests = "pref_interests";
  static const _keyLanguages = "pref_languages";

  static const _keyBio = "profile_bio";
  static const _keyFullName = "profile_fullName";
  static const _keyGender = "profile_gender";
  static const _keyProfession = "profile_profession";
  static const _keyProfilePhoto = "profile_photo";
  static const _keyDOB = "profile_dob";

  static const _keyIsProfileUpdated = "status_profile_updated";
  static const _keyIsPrefUpdated = "status_pref_updated";
  static const _keyIsLoggedIn = "status_logged_in";

  // ---------------- UserAuth ----------------
  static Future<void> saveUserAuth({
    String? token,
    String? email,
    String? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) await prefs.setString(_keyToken, token);
    if (email != null) await prefs.setString(_keyEmail, email);
    if (userId != null) await prefs.setString(_keyUserId, userId);
  }

  static Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_keyToken);
  static Future<String?> getEmail() async =>
      (await SharedPreferences.getInstance()).getString(_keyEmail);
  static Future<String?> getUserId() async =>
      (await SharedPreferences.getInstance()).getString(_keyUserId);

  // ---------------- UserPref ----------------
  static Future<void> saveUserPref({
    int? ageMin,
    int? ageMax,
    String? locationType,
    double? locationLat,
    double? locationLng,
    String? locationCity,
    String? locationCountry,
    int? distancePreference,
    List<String>? gallery,
    List<String>? genderPreference,
    List<String>? interests,
    List<String>? languages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (ageMin != null) await prefs.setInt(_keyAgeMin, ageMin);
    if (ageMax != null) await prefs.setInt(_keyAgeMax, ageMax);
    if (locationType != null)
      await prefs.setString(_keyLocationType, locationType);
    if (locationLat != null)
      await prefs.setDouble(_keyLocationLat, locationLat);
    if (locationLng != null)
      await prefs.setDouble(_keyLocationLng, locationLng);
    if (locationCity != null)
      await prefs.setString(_keyLocationCity, locationCity);
    if (locationCountry != null)
      await prefs.setString(_keyLocationCountry, locationCountry);
    if (distancePreference != null)
      await prefs.setInt(_keyDistancePref, distancePreference);
    if (gallery != null) await prefs.setStringList(_keyGallery, gallery);
    if (genderPreference != null)
      await prefs.setStringList(_keyGenderPref, genderPreference);
    if (interests != null) await prefs.setStringList(_keyInterests, interests);
    if (languages != null) await prefs.setStringList(_keyLanguages, languages);
  }

  static Future<void> saveInterests({List<String>? interests}) async {
    final prefs = await SharedPreferences.getInstance();
    if (interests != null) await prefs.setStringList(_keyInterests, interests);
  }

  static Future<void> saveIanguage({List<String>? languages}) async {
    final prefs = await SharedPreferences.getInstance();
    if (languages != null) await prefs.setStringList(_keyLanguages, languages);
  }

  static Future<int?> getAgeMin() async =>
      (await SharedPreferences.getInstance()).getInt(_keyAgeMin);
  static Future<int?> getAgeMax() async =>
      (await SharedPreferences.getInstance()).getInt(_keyAgeMax);
  static Future<String?> getLocationType() async =>
      (await SharedPreferences.getInstance()).getString(_keyLocationType);
  static Future<double?> getLocationLat() async =>
      (await SharedPreferences.getInstance()).getDouble(_keyLocationLat);
  static Future<double?> getLocationLng() async =>
      (await SharedPreferences.getInstance()).getDouble(_keyLocationLng);
  static Future<String?> getLocationCity() async =>
      (await SharedPreferences.getInstance()).getString(_keyLocationCity);
  static Future<String?> getLocationCountry() async =>
      (await SharedPreferences.getInstance()).getString(_keyLocationCountry);
  static Future<int?> getDistancePreference() async =>
      (await SharedPreferences.getInstance()).getInt(_keyDistancePref);
  static Future<List<String>?> getGallery() async =>
      (await SharedPreferences.getInstance()).getStringList(_keyGallery);
  static Future<List<String>?> getGenderPreference() async =>
      (await SharedPreferences.getInstance()).getStringList(_keyGenderPref);
  static Future<List<String>?> getInterests() async =>
      (await SharedPreferences.getInstance()).getStringList(_keyInterests);
  static Future<List<String>?> getLanguages() async =>
      (await SharedPreferences.getInstance()).getStringList(_keyLanguages);

  // ---------------- UserProfile ----------------
  static Future<void> saveUserProfile({
    String? bio,
    String? fullName,
    String? gender,
    String? profession,
    String? profilePhotoUrl,
    String? dateOfBirth,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (bio != null) await prefs.setString(_keyBio, bio);
    if (fullName != null) await prefs.setString(_keyFullName, fullName);
    if (gender != null) await prefs.setString(_keyGender, gender);
    if (profession != null) await prefs.setString(_keyProfession, profession);
    if (profilePhotoUrl != null)
      await prefs.setString(_keyProfilePhoto, profilePhotoUrl);
    if (dateOfBirth != null) await prefs.setString(_keyDOB, dateOfBirth);
  }

  static Future<String?> getBio() async =>
      (await SharedPreferences.getInstance()).getString(_keyBio);
  static Future<String?> getFullName() async =>
      (await SharedPreferences.getInstance()).getString(_keyFullName);
  static Future<String?> getGender() async =>
      (await SharedPreferences.getInstance()).getString(_keyGender);
  static Future<String?> getProfession() async =>
      (await SharedPreferences.getInstance()).getString(_keyProfession);
  static Future<String?> getProfilePhotoUrl() async =>
      (await SharedPreferences.getInstance()).getString(_keyProfilePhoto);
  static Future<String?> getDateOfBirth() async =>
      (await SharedPreferences.getInstance()).getString(_keyDOB);

  // ---------------- Status ----------------
  static Future<void> saveStatus({
    bool? isProfileUpdated,
    bool? isPrefUpdated,
    bool? isLoggedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (isProfileUpdated != null)
      await prefs.setBool(_keyIsProfileUpdated, isProfileUpdated);
    if (isPrefUpdated != null)
      await prefs.setBool(_keyIsPrefUpdated, isPrefUpdated);
    if (isLoggedIn != null) await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  static Future<bool?> getIsProfileUpdated() async =>
      (await SharedPreferences.getInstance()).getBool(_keyIsProfileUpdated);
  static Future<bool?> getIsPrefUpdated() async =>
      (await SharedPreferences.getInstance()).getBool(_keyIsPrefUpdated);
  static Future<bool?> getIsLoggedIn() async =>
      (await SharedPreferences.getInstance()).getBool(_keyIsLoggedIn);

  // ---------------- Clear All ----------------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
