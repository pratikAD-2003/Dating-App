import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/chat/get_chat_user_res_model.dart';
import 'package:dating_app/data/riverpod/chat_notifier.dart';
import 'package:dating_app/data/riverpod/story_notifier.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/presentation/user/story_screen.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyMessagesScreen extends StatefulWidget {
  const MyMessagesScreen({super.key});

  @override
  State<MyMessagesScreen> createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
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

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: MyColors.constTheme),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyMessageAppBarSection(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: MySearchField(
                      controller: searchController,
                      hintText: 'Search',
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyMessageActivitySection(userId: userId ?? ""),
                          MyMessageChatsSection(userId: userId ?? ""),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class MyMessageChatsSection extends ConsumerStatefulWidget {
  const MyMessageChatsSection({super.key, required this.userId});
  final String userId;
  @override
  ConsumerState<MyMessageChatsSection> createState() =>
      _MyMessageChatsSectionState();
}

class _MyMessageChatsSectionState extends ConsumerState<MyMessageChatsSection> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).fetchChats(widget.userId);
    });

    // ✅ pagination listener
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 100) {
        final notifier = ref.read(chatNotifierProvider.notifier);
        notifier.fetchChats(widget.userId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    ref.listen(chatNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {},
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: MyBoldText(
              text: 'Messages',
              color: MyColors.textColor(context),
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          chatState.when(
            data: (chats) => ListView.builder(
              itemCount: chats.length,
              shrinkWrap: true,
              controller: _controller,
              itemBuilder: (_, i) {
                final chat = chats[i];
                return ChatUserCard(
                  data: chat,
                  onStoryClick: () {},
                  onClick: () {},
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(err.toString())),
          ),
        ],
      ),
    );
  }
}

class ChatUserCard extends StatelessWidget {
  const ChatUserCard({
    super.key,
    required this.data,
    required this.onStoryClick,
    required this.onClick,
  });

  final Chats data;
  final VoidCallback onStoryClick;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            StoryCircularCard(
              size: 55,
              imageUrl: data.participant?.profilePhotoUrl,
              onClick: () => onStoryClick(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBoldText(
                        text: data.participant?.fullName ?? "N/A",
                        color: MyColors.textColor(context),
                        fontSize: 18,
                        textAlign: TextAlign.center,
                      ),
                      MyRegularText(
                        text: Utils.formatChatTime(data.updatedAt),
                        color: MyColors.hintColor(context),
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyRegularText(
                        text: (data.byMe ?? false)
                            ? "You: ${data.lastMessage}"
                            : "${data.lastMessage}",
                        color: MyColors.textColor(context),
                        fontSize: 15,
                        textAlign: TextAlign.center,
                      ),
                      if ((data.isSeenMessage != true))
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: MyColors.constTheme,
                          ),
                          height: 22,
                          width: 22,
                          child: MyBoldText(
                            text: '${data.unseenMessagesCount}',
                            color: MyColors.constWhite,
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 0.5,
                    width: double.infinity,
                    color: MyColors.hintColor(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMessageActivitySection extends ConsumerStatefulWidget {
  const MyMessageActivitySection({super.key, required this.userId});
  final String userId;
  @override
  ConsumerState<MyMessageActivitySection> createState() =>
      _MyMessageActivitySectionState();
}

class _MyMessageActivitySectionState
    extends ConsumerState<MyMessageActivitySection> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storyNotifierProvider.notifier).fetchStories(widget.userId);
    });

    // ✅ pagination listener
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 100) {
        final notifier = ref.read(storyNotifierProvider.notifier);
        notifier.fetchStories(widget.userId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(storyNotifierProvider);
    ref.listen(storyNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) async {},
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

    return storyState.when(
      data: (data) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: MyBoldText(
                text: 'Activities',
                color: MyColors.textColor(context),
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    right: 12.0,
                    left: index == 0 ? 20 : 0,
                  ),
                  child: index == 0
                      ? MyStoryCard(
                          imageUrl: data[index].profilePhotoUrl ?? "",
                          isSeen: data[index].isSeen ?? true,
                          onStoryClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryScreen(
                                  userId: data[index].userId ?? "",
                                ),
                              ),
                            );
                          },
                          onStoryAddClick: () {},
                        )
                      : StoryCard(
                          name: data[index].fullName ?? "N/A",
                          imageUrl: data[index].profilePhotoUrl ?? "",
                          isSeen: data[index].isSeen ?? true,
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryScreen(
                                  userId: data[index].userId ?? "",
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(err.toString())),
    );
  }
}

class MyMessageAppBarSection extends StatelessWidget {
  const MyMessageAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyBoldText(
            text: 'Messages',
            color: MyColors.textColor(context),
            fontSize: 28,
          ),
          // MyIconButton(
          //   icon: 'assets/images/filter.png',
          //   padding: 12,
          //   size: 20,
          //   onClick: () => {
          //     Navigator.push(
          //       context,
          //       // MaterialPageRoute(builder: (context) => ChatScreen()),
          //       // MaterialPageRoute(builder: (context) => StoryScreen()),
          //       MaterialPageRoute(builder: (context) => UserDetailScreen()),
          //     ),
          //   },
          // ),
        ],
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isSeen,
    required this.onClick,
  });
  final String name;

  final String imageUrl;
  final bool isSeen;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          StoryCircularCard(
            size: 60,
            imageUrl: imageUrl,
            isSeenStory: isSeen,
            onClick: () => onClick(),
          ),
          SizedBox(
            width: 65,
            child: MyBoldText(
              text: name,
              color: MyColors.textColor(context),
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class MyStoryCard extends StatelessWidget {
  const MyStoryCard({
    super.key,
    required this.imageUrl,
    required this.isSeen,
    required this.onStoryClick,
    required this.onStoryAddClick,
  });
  final String imageUrl;
  final bool isSeen;
  final VoidCallback onStoryClick;
  final VoidCallback onStoryAddClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 2,
      children: [
        Stack(
          children: [
            Positioned(
              child: StoryCircularCard(
                size: 65,
                imageUrl: imageUrl,
                isSeenStory: isSeen,
                onClick: () => onStoryClick(),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => onStoryAddClick(),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: MyColors.constTheme,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.add, color: MyColors.constWhite),
                ),
              ),
            ),
          ],
        ),
        MyBoldText(
          text: 'My Story',
          color: MyColors.textColor(context),
          fontSize: 16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class StoryCircularCard extends StatelessWidget {
  const StoryCircularCard({
    super.key,
    this.size = 60,
    this.border = 2.4,
    this.imageUrl,
    this.isSeenStory = true,
    required this.onClick,
  });
  final double size;
  final double border;
  final String? imageUrl;
  final VoidCallback onClick;
  final bool isSeenStory;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: isSeenStory
                ? [Colors.transparent, Colors.transparent]
                : [
                    Color(0xFFF27121), // purple
                    Color(0xFFE94057), // pink
                    Color(0xFF8A2387), // pink
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(border),
        child: Container(
          padding: EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            color: MyColors.background(context),
            borderRadius: BorderRadius.circular(50),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    height: size,
                    width: size,
                  )
                : Image.asset(
                    'assets/images/m2.jpg',
                    fit: BoxFit.cover,
                    height: size,
                    width: size,
                  ),
          ),
        ),
      ),
    );
  }
}
