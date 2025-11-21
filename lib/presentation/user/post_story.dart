import 'dart:io';

import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/riverpod/story_notifier.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PostStory extends ConsumerStatefulWidget {
  const PostStory({super.key});

  @override
  ConsumerState<PostStory> createState() => _PostStoryState();
}

class _PostStoryState extends ConsumerState<PostStory> {
  String? userId;
  bool _isLoading = true;

  @override
  void initState() {
    _loadProfileData();
    super.initState();
  }

  Future<void> _loadProfileData() async {
    String? id = await PrefsHelper.getUserId();

    // Update UI if data found locally
    setState(() {
      userId = id;
      _isLoading = false;
    });
  }

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    Permission permission;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.photos.isLimited) {
        permission = Permission.photos;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }

    final status = await permission.request();

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final postStoryState = ref.watch(uploadStoryNotifierProvider);

    ref.listen(uploadStoryNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {
          if (user != null) {
            final snackBar = SnackBar(
              content: MyBoldText(
                text: "Story Uploaded.",
                fontSize: 16,
                color: MyColors.themeColor(context),
              ),
              duration: const Duration(seconds: 2), // ⏱ Customize duration
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
              _,
            ) async {
              Navigator.pop(context);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 15,
                            children: [
                              MyBackButton(),
                              MyBoldText(
                                text: 'Add Story',
                                color: MyColors.textColor(context),
                                fontSize: 22,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: _selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: BoxBorder.all(
                                            width: 2,
                                            color: MyColors.borderColor(
                                              context,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () => _pickImage(),
                                          color: MyColors.borderColor(context),
                                          icon: Icon(Icons.add, size: 60),
                                        ),
                                      ),
                                      MyRegularText(
                                        text: 'Click here to add',
                                        color: MyColors.hintColor(context),
                                        fontSize: 14,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          MyButton(
                            text: 'Add',
                            isLoading: postStoryState.isLoading,
                            onClick: () async {
                              if (_selectedImage != null) {
                                await ref
                                    .read(uploadStoryNotifierProvider.notifier)
                                    .uploadStory(userId ?? "", _selectedImage!);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
