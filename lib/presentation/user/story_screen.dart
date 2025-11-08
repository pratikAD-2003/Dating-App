import 'package:dating_app/presentation/bottom_nav/my_messages_screen.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPaused = false;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _controller.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onLongPress: () {
                  _isLongPressed = true;
                  _togglePlayPause();
                },
                onLongPressEnd: (details) {
                  _isLongPressed = false;
                  _togglePlayPause();
                },
                child: Image.asset('assets/images/m2.jpg', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: StoryTopBar(
                isLongPressed: _isLongPressed,
                controller: _controller,
                onClose: () {
                  Navigator.pop(context);
                },
                name: 'Emma',
                time: '04:05 PM',
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: AnimatedOpacity(
                opacity: _isLongPressed ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: AnimatedSlide(
                  offset: _isLongPressed ? const Offset(0, 0.2) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: StoryMsgInputSection(onText: (message) {}),
                ),
              ),
            ),
          ],
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
                    const StoryCircularCard(size: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyBoldText(
                          text: name,
                          fontSize: 20,
                          color: MyColors.constWhite,
                        ),
                        MyRegularText(
                          text: time,
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
