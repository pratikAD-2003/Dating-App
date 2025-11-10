import 'dart:io';

import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/riverpod/auth_notifier.dart';
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
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  TextEditingController genderController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  final List<String> genders = ["Male", "Female", "Non-binary", "Other"];
  final List<String> allCities = [
    "Mumbai",
    "Delhi",
    "Bengaluru",
    "Hyderabad",
    "Chennai",
    "Pune",
    "Kolkata",
    "Jaipur",
    "Ahmedabad",
    "Surat",
  ];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<String> filteredCities = [];
  List<File> photogalleryImages = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      _removeOverlay();
      setState(() => filteredCities = []);
    } else {
      filteredCities = allCities
          .where((city) => city.toLowerCase().contains(query))
          .toList();
      _showOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay(); // remove old one if exists
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width - 40, // adjust to match your field width
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // position below your field
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: MyColors.background(context),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                final city = filteredCities[index];
                return InkWell(
                  onTap: () {
                    searchController.text = city;
                    _removeOverlay();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      city,
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
        data: (user) {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: user.message ?? "Profile Updated.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(snackBar).closed.then((_) {});
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
                        text: 'Skip',
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
                            SizedBox(height: 10),
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
                                controller: searchController,
                                hintText: 'Search your city',
                              ),
                            ),
                            SizedBox.shrink(),
                            MyDropdown(
                              hint: 'Gender Preference',
                              options: genders,
                              onSelected: (selected) {
                                genderController.text = selected;
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
                            MyInputField(
                              controller: countryController,
                              hintText: 'Country',
                              onRead: true,
                              condition: (text) {
                                return text.isNotEmpty;
                              },
                            ),
                            SizedBox.shrink(),
                            MyInputField(
                              controller: cityController,
                              hintText: 'City',
                              onRead: true,
                              condition: (text) {
                                return text.isNotEmpty;
                              },
                            ),
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
                    await ref
                        .read(updatePreferenceNotifierProvider.notifier)
                        .updatePref(
                          userId: '6911a82ceac3c0649ac99f80',
                          interests: [],
                          languages: [],
                          distancePreference: double.parse(
                            distanceController.text,
                          ),
                          ageRangePreference: [],
                          genderPreference: [genderController.text],
                          location: Location(
                            type: "Point",
                            city: "Bengluru",
                            country: "India",
                            coordinates: [77.5946, 12.9716],
                          ).toJson(),
                          images: photogalleryImages,
                        );
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
