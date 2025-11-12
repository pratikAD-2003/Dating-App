import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/data/riverpod/place_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/location_screen.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditLocation extends ConsumerStatefulWidget {
  const EditLocation({super.key});

  @override
  ConsumerState<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends ConsumerState<EditLocation> {
  TextEditingController genderController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController minAgeController = TextEditingController();
  TextEditingController maxAgeController = TextEditingController();

  final List<String> genders = ["Male", "Female", "Non-binary", "Other"];
  List<String> selectedGenders = [];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<String> filteredCities = [];
  List<File> photogalleryImages = [];

  List<String> gallery = [];
  List<String> gender = [];
  String? userId;
  bool _isLoading = true;
  Location? selectedPlace;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadProfileData() async {
    final dis = await PrefsHelper.getDistancePreference();
    final genderList = await PrefsHelper.getGenderPreference();
    final minA = await PrefsHelper.getAgeMin();
    final maxA = await PrefsHelper.getAgeMax();
    String? id = await PrefsHelper.getUserId();
    String? city = await PrefsHelper.getLocationCity();
    String? country = await PrefsHelper.getLocationCountry();
    String? type = await PrefsHelper.getLocationType();
    double? long = await PrefsHelper.getLocationLng();
    double? lat = await PrefsHelper.getLocationLat();
    // Update UI if data found locally
    setState(() {
      userId = id;
      distanceController.text = dis.toString();
      selectedGenders = genderList ?? [];
      minAgeController.text = minA.toString();
      maxAgeController.text = maxA.toString();
      selectedPlace = Location(
        city: city,
        coordinates: [long ?? 0.0, lat ?? 0.0],
        country: country,
        type: type,
      );
      searchController.text = city ?? '';
      _isLoading = false;
    });
  }

  void _onSearchChanged() async {
    final query = searchController.text.trim();

    // If user modifies the text after selecting, clear the selectedPlace
    if (selectedPlace != null && searchController.text != selectedPlace!.city) {
      setState(() => selectedPlace = null);
    }

    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    _showOverlay(isLoading: true);

    final suggestions = await ref.read(placeSearchProvider(query).future);

    if (suggestions.isNotEmpty && selectedPlace == null) {
      _showOverlay(suggestions: suggestions);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay({bool isLoading = false, List<Location>? suggestions}) {
    _removeOverlay();
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: MyColors.background(context),
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MyColors.themeColor(context),
                      ),
                    ),
                  )
                : (suggestions == null || suggestions.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No location found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.textColor(context),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Set selectedPlace
                          selectedPlace = suggestions[index];

                          // Update the input field
                          searchController.text = selectedPlace!.city ?? '';

                          // Hide the overlay after selection
                          _removeOverlay();

                          debugPrint(
                            "📍 Selected place: ${selectedPlace!.toJson()}",
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            suggestions[index].city ?? 'Unknown location',
                            style: TextStyle(
                              color: MyColors.textColor(context),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(updatePreferenceNotifierProvider);

    ref.listen(updatePreferenceNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Preferences Updated.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              await PrefsHelper.saveUserPref(
                ageMin: user.data?.ageRangePreference?.min,
                ageMax: user.data?.ageRangePreference?.max,
                locationType: "Point",
                locationLat: user.data?.location?.coordinates?.first,
                locationLng: user.data?.location?.coordinates?.last,
                locationCity: user.data?.location?.city,
                locationCountry: user.data?.location?.country,
                distancePreference: user.data?.distancePreference,
                gallery: user.data?.gallery,
                genderPreference: user.data?.genderPreference,
                interests: user.data?.interests,
                languages: user.data?.languages,
              );
            });
          }
        },
        error: (err, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MyBoldText(
                text: '$err',
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: MyColors.constTheme),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 15,
                              children: [
                                MyBackButton(),
                                MyBoldText(
                                  text: 'Edit Preferences',
                                  color: MyColors.textColor(context),
                                  fontSize: 22,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Column(
                                spacing: 10,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      MyBoldText(
                                        text:
                                            'Gallery Images (optional). (max-5)',
                                        color: MyColors.textColor(context),
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  MultiImagePickerWidget(
                                    maxImages: 5,
                                    onImagesChanged: (image) {
                                      setState(() {
                                        photogalleryImages = image;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  CompositedTransformTarget(
                                    link: _layerLink,
                                    child: MySearchField(
                                      icon: "assets/images/location.png",
                                      controller: searchController,
                                      hintText: 'Search your city',
                                    ),
                                  ),
                                  SizedBox.shrink(),
                                  Row(
                                    children: [
                                      MyBoldText(
                                        text: 'Gender Preference',
                                        color: MyColors.textColor(context),
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox.shrink(),
                                  MyMultiSelectDropdown(
                                    hint: 'Gender Preference',
                                    options: genders,
                                    initialValues: selectedGenders,
                                    onSelected: (selectedList) {
                                      setState(() {
                                        selectedGenders = selectedList;
                                      });
                                    },
                                  ),
                                  SizedBox.shrink(),
                                  MyInputField(
                                    controller: distanceController,
                                    hintText: 'Distance Preference (in Km)',
                                    digitOnly: true,
                                    condition: (text) {
                                      return text.isNotEmpty;
                                    },
                                  ),
                                  SizedBox.shrink(),
                                  Row(
                                    children: [
                                      MyBoldText(
                                        text: 'Age Preference (optional)',
                                        color: MyColors.textColor(context),
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox.shrink(),
                                  MyInputField(
                                    controller: minAgeController,
                                    hintText: 'Min Age.(18+)',
                                    digitOnly: true,
                                    condition: (text) {
                                      if (text.isEmpty)
                                        return false; // invalid if empty
                                      final value = int.tryParse(text);
                                      if (value == null)
                                        return false; // invalid if not a number
                                      return value >= 18 &&
                                          value <= 50; // min/max age range
                                    },
                                  ),
                                  SizedBox.shrink(),
                                  MyInputField(
                                    controller: maxAgeController,
                                    hintText: 'Max Age.(50-)',
                                    digitOnly: true,
                                    condition: (text) {
                                      if (text.isEmpty) return false;
                                      final value = int.tryParse(text);
                                      if (value == null) return false;
                                      return value >= 18 && value <= 50;
                                    },
                                  ),
                                  SizedBox.shrink(),
                                  SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MyButton(
                        text: 'Update',
                        isLoading: authState.isLoading,
                        onClick: () async {
                          String? userId = await PrefsHelper.getUserId();
                          if (userId != null) {
                            await ref
                                .read(updatePreferenceNotifierProvider.notifier)
                                .updatePref(
                                  userId: userId,
                                  interests: [],
                                  languages: [],
                                  distancePreference: double.parse(
                                    distanceController.text,
                                  ),
                                  ageRangePreference: AgeRangePreference(
                                    min: double.parse(
                                      minAgeController.text,
                                    ).toInt(),
                                    max: double.parse(
                                      maxAgeController.text,
                                    ).toInt(),
                                  ),
                                  genderPreference: selectedGenders,
                                  location: Location(
                                    type: "Point",
                                    city: selectedPlace?.city,
                                    country: selectedPlace?.country,
                                    coordinates: selectedPlace?.coordinates,
                                  ).toJson(),
                                  images: photogalleryImages,
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
