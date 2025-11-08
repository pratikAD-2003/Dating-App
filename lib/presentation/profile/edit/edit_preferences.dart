import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class EditPreferences extends StatefulWidget {
  const EditPreferences({super.key});

  @override
  State<EditPreferences> createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
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
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Column(
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
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          spacing: 10,
                          children: [
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
                child: MyButton(text: 'Update', onClick: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
