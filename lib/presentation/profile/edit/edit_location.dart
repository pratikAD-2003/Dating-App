import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
import 'package:dating_app/data/riverpod/place_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  List<String> savedImages = [];
  List<String> removedImages = [];
  List<File> photogalleryImages = [];

  List<String> gallery = [];
  List<String> gender = [];
  List<String> interest = [];
  List<String> language = [];
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
    final interests = await PrefsHelper.getInterests();
    final languages = await PrefsHelper.getLanguages();
    String? id = await PrefsHelper.getUserId();
    String? city = await PrefsHelper.getLocationCity();
    String? country = await PrefsHelper.getLocationCountry();
    String? type = await PrefsHelper.getLocationType();
    double? long = await PrefsHelper.getLocationLng();
    double? lat = await PrefsHelper.getLocationLat();
    final savedPics = await PrefsHelper.getGallery();
    // Update UI if data found locally
    setState(() {
      userId = id;
      distanceController.text = dis.toString();
      selectedGenders = genderList ?? [];
      savedImages = savedPics ?? [];
      minAgeController.text = minA.toString();
      maxAgeController.text = maxA.toString();
      interest = interests ?? [];
      language = languages ?? [];
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
    final authState = ref.watch(updateAndRemovePreferenceNotifierProvider);

    ref.listen(updateAndRemovePreferenceNotifierProvider, (previous, next) {
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
                                  EditPrefImagePickerWidget(
                                    onSavedImagesRemoved: (imageUrl) {
                                      setState(() {
                                        removedImages.addAll(imageUrl);
                                      });
                                    },
                                    savedImages: savedImages,
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
                                .read(
                                  updateAndRemovePreferenceNotifierProvider
                                      .notifier,
                                )
                                .updatePref(
                                  userId: userId,
                                  interests: interest,
                                  languages: language,
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
                                  removedImages: removedImages,
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

class EditPrefImagePickerWidget extends StatefulWidget {
  final Function(List<File>) onImagesChanged;
  final Function(List<String>) onSavedImagesRemoved;
  final int maxImages;
  final List<String> savedImages;

  const EditPrefImagePickerWidget({
    super.key,
    required this.onImagesChanged,
    required this.onSavedImagesRemoved,
    this.maxImages = 5,
    required this.savedImages,
  });

  @override
  State<EditPrefImagePickerWidget> createState() =>
      _EditPrefImagePickerWidgetState();
}

class _EditPrefImagePickerWidgetState extends State<EditPrefImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = [];
  List<String> _savedImages = [];
  List<String> _removedSavedImages = [];

  @override
  void initState() {
    super.initState();
    _savedImages = List.from(widget.savedImages);
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    final newImages = pickedFiles.map((x) => File(x.path)).toList();

    setState(() {
      _selectedImages = [
        ..._selectedImages,
        ...newImages,
      ].take(widget.maxImages - _savedImages.length).toList();
    });

    widget.onImagesChanged(_selectedImages);
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  void _removeSavedImage(int index) {
    final removedUrl = _savedImages[index];

    setState(() {
      _savedImages.removeAt(index);
      _removedSavedImages.add(removedUrl);
    });

    widget.onSavedImagesRemoved(_removedSavedImages);
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = _savedImages.length + _selectedImages.length;
    final canAddMore = totalImages < widget.maxImages;

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // OLD SAVED IMAGES
          ..._savedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
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
                      onTap: () => _removeSavedImage(index),
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
              ),
            );
          }),

          // NEWLY PICKED IMAGES
          ..._selectedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeSelectedImage(index),
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
              ),
            );
          }),

          // ADD NEW IMAGE BUTTON
          if (canAddMore)
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.add_a_photo, size: 32)),
              ),
            ),
        ],
      ),
    );
  }
}
