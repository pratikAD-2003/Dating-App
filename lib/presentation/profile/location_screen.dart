import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/data/riverpod/place_notifier.dart';
import 'package:dating_app/presentation/bottom_nav/bottom_nav.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/profile/update_profile.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({
    super.key,
    required this.interests,
    required this.languages,
  });
  final List<String> interests;
  final List<String> languages;
  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
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

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  Location? selectedPlace;

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
                text: user.message ?? "Profile Updated.",
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
              await PrefsHelper.saveStatus(
                isLoggedIn: true,
                isProfileUpdated: true,
                isPrefUpdated: true,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
                (Route<dynamic> route) => false,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkipText(
                        text: '',
                        backEnable: true,
                        onClick: () {},
                        onBackClick: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      MyBoldText(
                        text: 'Match Preferences',
                        color: MyColors.textColor(context),
                        fontSize: 28,
                      ),
                      const SizedBox(height: 5),
                      MyRegularText(
                        text: "Find someone who’s closer than you think 💕.",
                        color: MyColors.textLightColor(context),
                        textAlign: TextAlign.start,
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
                                  text: 'Gallery Images (optional). (max-5)',
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
                                  text: 'Age Preference (optional)',
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
                  text: 'Finished',
                  isLoading: authState.isLoading,
                  onClick: () async {
                    String? userId = await PrefsHelper.getUserId();
                    if (userId != null) {
                      await ref
                          .read(updatePreferenceNotifierProvider.notifier)
                          .updatePref(
                            userId: userId,
                            interests: widget.interests,
                            languages: widget.languages,
                            distancePreference: double.parse(
                              distanceController.text,
                            ),
                            ageRangePreference: AgeRangePreference(
                              min: double.parse(minAgeController.text).toInt(),
                              max: double.parse(maxAgeController.text).toInt(),
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

class MultiImagePickerWidget extends StatefulWidget {
  final Function(List<File>) onImagesChanged;
  final int maxImages;

  const MultiImagePickerWidget({
    super.key,
    required this.onImagesChanged,
    this.maxImages = 5,
  });

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final status = await Permission.photos.request();

    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Permission denied')));
      }
      return;
    }

    final pickedFiles = await _picker.pickMultiImage();

    final newImages = pickedFiles.map((x) => File(x.path)).toList();

    setState(() {
      // ✅ Limit to maxImages
      _selectedImages = [
        ..._selectedImages,
        ...newImages,
      ].take(widget.maxImages).toList();
    });

    widget.onImagesChanged(_selectedImages);
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length < widget.maxImages
            ? _selectedImages.length + 1
            : _selectedImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _selectedImages.length &&
              _selectedImages.length < widget.maxImages) {
            return GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.hintColor(context)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 32,
                    color: MyColors.hintColor(context),
                  ),
                ),
              ),
            );
          }

          // 🖼️ Image Preview Box
          final image = _selectedImages[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
