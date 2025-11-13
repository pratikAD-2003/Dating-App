import 'package:dating_app/data/model/response/story/get_user_stories_res_model.dart';
import 'package:dating_app/data/riverpod/story_notifier.dart';
import 'package:dating_app/presentation/bottom_nav/my_messages_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key, required this.userId});
  final String userId;
  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

// class _StoryScreenState extends ConsumerState<StoryScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isPaused = false;
//   bool _isLongPressed = false;
//   int _currentStoryIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     );
//     _startStory();
//   }

//   void _startStory() {
//     _controller.forward(from: 0);
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _nextStory();
//       }
//     });
//   }

//   void _nextStory() {
//     if (_currentStoryIndex < (sampleData.user!.stories!.length - 1)) {
//       setState(() => _currentStoryIndex++);
//       _controller.reset();
//       _controller.forward();
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   void _previousStory() {
//     if (_currentStoryIndex > 0) {
//       setState(() => _currentStoryIndex--);
//       _controller.reset();
//       _controller.forward();
//     }
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_isPaused) {
//         _controller.forward();
//       } else {
//         _controller.stop();
//       }
//       _isPaused = !_isPaused;
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final currentStory = sampleData.user!.stories![_currentStoryIndex];
//     final storyState = ref.watch(getUserStoriesNotifierProvider);
//     ref.listen(getUserStoriesNotifierProvider, (previous, next) {
//       next.whenOrNull(
//         data: (user) async {},
//         error: (err, st) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: MyBoldText(
//                 text: '$err',
//                 fontSize: 16,
//                 color: MyColors.themeColor(context),
//               ),
//             ),
//           );
//         },
//       );
//     });

//     return Scaffold(
//       backgroundColor: MyColors.background(context),
//       body: SafeArea(
//         child: storyState.when(
//           data: (data) => Stack(
//             children: [
//               // Story content
//               Positioned.fill(
//                 child: GestureDetector(
//                   onLongPress: () {
//                     _isLongPressed = true;
//                     _togglePlayPause();
//                   },
//                   onLongPressEnd: (_) {
//                     _isLongPressed = false;
//                     _togglePlayPause();
//                   },
//                   onTapUp: (details) {
//                     final width = MediaQuery.of(context).size.width;
//                     if (details.globalPosition.dx < width / 2) {
//                       _previousStory();
//                     } else {
//                       _nextStory();
//                     }
//                   },
//                   child: Image.network(
//                     // currentStory.mediaUrl!,
//                     data?.user?.stories?[_currentStoryIndex].mediaUrl ?? "",
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, progress) {
//                       if (progress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: MyColors.constTheme,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // Top bar with progress
//               Positioned(
//                 top: 15,
//                 left: 15,
//                 right: 15,
//                 child: StoryTopBar(
//                   isLongPressed: _isLongPressed,
//                   controller: _controller,
//                   onClose: () => Navigator.pop(context),
//                   // name: sampleData.user!.fullName ?? "",
//                   // time: currentStory.createdAt ?? "",
//                   name: data?.user?.fullName ?? "",
//                   time: Utils.formatChatTime(
//                     data?.user?.stories?[_currentStoryIndex].createdAt,
//                   ),
//                 ),
//               ),

//               // Bottom message bar
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 10,
//                 child: AnimatedOpacity(
//                   opacity: _isLongPressed ? 0.0 : 1.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: AnimatedSlide(
//                     offset: _isLongPressed ? const Offset(0, 0.2) : Offset.zero,
//                     duration: const Duration(milliseconds: 200),
//                     child: StoryMsgInputSection(onText: (message) {}),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (err, _) => Center(child: Text(err.toString())),
//         ),
//       ),
//     );
//   }
// }
class _StoryScreenState extends ConsumerState<StoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPaused = false;
  bool _isLongPressed = false;
  int _currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // ✅ initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getUserStoriesNotifierProvider.notifier)
          .getUserStories(widget.userId);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  void _startStory() {
    _controller
      ..reset()
      ..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    final stories = _getStories();
    if (stories == null) return;

    if (_currentStoryIndex < stories.length - 1) {
      setState(() => _currentStoryIndex++);
      _controller
        ..reset()
        ..forward();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    final stories = _getStories();
    if (stories == null) return;

    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _controller
        ..reset()
        ..forward();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPaused) {
        _controller.forward();
      } else {
        _controller.stop();
      }
      _isPaused = !_isPaused;
    });
  }

  List<Stories>? _getStories() {
    final storyState = ref.read(getUserStoriesNotifierProvider);
    return storyState.maybeWhen(
      data: (data) => data?.user?.stories,
      orElse: () => null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(getUserStoriesNotifierProvider);

    ref.listen(getUserStoriesNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          // Restart story animation only if data newly loaded
          if (user?.user?.stories?.isNotEmpty ?? false) {
            _currentStoryIndex = 0;
            _startStory();
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
        child: storyState.when(
          data: (data) {
            final stories = data?.user?.stories ?? [];
            if (stories.isEmpty) {
              return const Center(child: Text("No stories available"));
            }

            final currentStory = stories[_currentStoryIndex];
            return Stack(
              children: [
                // Story content
                Positioned.fill(
                  child: GestureDetector(
                    onLongPress: () {
                      _isLongPressed = true;
                      _togglePlayPause();
                    },
                    onLongPressEnd: (_) {
                      _isLongPressed = false;
                      _togglePlayPause();
                    },
                    onTapUp: (details) {
                      final width = MediaQuery.of(context).size.width;
                      if (details.globalPosition.dx < width / 2) {
                        _previousStory();
                      } else {
                        _nextStory();
                      }
                    },
                    child: Image.network(
                      currentStory.mediaUrl ?? "",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: MyColors.constTheme,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, size: 60),
                      ),
                    ),
                  ),
                ),

                // Top bar
                Positioned(
                  top: 15,
                  left: 15,
                  right: 15,
                  child: StoryTopBar(
                    isLongPressed: _isLongPressed,
                    controller: _controller,
                    onClose: () => Navigator.pop(context),
                    name: data?.user?.fullName ?? "",
                    time:
                        data?.user?.stories?[_currentStoryIndex].createdAt ??
                        "",
                  ),
                ),

                // Message input
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: AnimatedOpacity(
                    opacity: _isLongPressed ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedSlide(
                      offset: _isLongPressed
                          ? const Offset(0, 0.2)
                          : Offset.zero,
                      duration: const Duration(milliseconds: 200),
                      child: StoryMsgInputSection(onText: (message) {}),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (err, _) => Center(child: Text(err.toString())),
        ),
      ),
    );
  }
}

class StoryTopBar extends StatelessWidget {
  final bool isLongPressed;
  final AnimationController controller;
  final VoidCallback onClose;
  final String name;
  final String time;

  const StoryTopBar({
    super.key,
    required this.isLongPressed,
    required this.controller,
    required this.onClose,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLongPressed ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedSlide(
        offset: isLongPressed ? const Offset(0, -0.2) : Offset.zero,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: controller.value,
                    backgroundColor: MyColors.constWhite,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      MyColors.constTheme,
                    ),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(10),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    StoryCircularCard(size: 50, onClick: () {}),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyBoldText(
                          text: name,
                          fontSize: 20,
                          color: MyColors.constWhite,
                        ),
                        MyRegularText(
                          text: Utils.formatChatTime(time),
                          color: MyColors.constWhite,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
                MyIconButton(
                  icon: 'assets/images/close.png',
                  padding: 6,
                  onClick: onClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoryMsgInputSection extends StatelessWidget {
  const StoryMsgInputSection({super.key, required this.onText});
  final Function(String message) onText;

  @override
  Widget build(BuildContext context) {
    TextEditingController chatController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 5,
        children: [
          Expanded(
            child: MyChatInputField(
              controller: chatController,
              hintText: 'Comment',
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              onText(chatController.text);
              chatController.clear();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.chatBoxColor(context),
              ),
              height: 55,
              width: 55,
              child: Icon(
                Icons.send,
                color: MyColors.textColor(context),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
