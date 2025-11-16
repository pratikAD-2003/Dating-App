import 'package:dating_app/data/local/prefs_helper.dart';
import 'package:dating_app/data/model/response/chat/chat_user_list_res_model.dart';
import 'package:dating_app/data/model/response/chat/msg_res_model.dart';
import 'package:dating_app/data/riverpod/chat_notifier.dart';
import 'package:dating_app/presentation/bottom_nav/my_messages_screen.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:dating_app/presentation/user/story_screen.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.data});
  final ChatUserListResModel data;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String? myUserId;
  @override
  void initState() {
    _loadProfileData();
    super.initState();
  }

  Future<void> _loadProfileData() async {
    String? id = await PrefsHelper.getUserId();

    setState(() {
      myUserId = id;
    });
  }

  void onSendPressed(String text) {
    final notifier = ref.read(
      sendMsgNotifierProvider({
        "userId": myUserId ?? "",
        "chatId": widget.data.chatId ?? "",
      }).notifier,
    );

    notifier.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            ChatScreenAppBarSection(
              name: widget.data.fullName ?? "",
              profile: widget.data.profilePhotoUrl ?? "",
              userId: widget.data.userId ?? "",
            ),
            ChatBox(chatId: widget.data.chatId ?? "", myUserId: myUserId ?? ""),
            ChatInputSection(
              onText: (message) {
                onSendPressed(message);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputSection extends StatelessWidget {
  const ChatInputSection({super.key, required this.onText});
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
              hintText: 'Message',
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

class ChatBox extends ConsumerStatefulWidget {
  const ChatBox({super.key, required this.chatId, required this.myUserId});
  final String chatId;
  final String myUserId;
  @override
  ConsumerState<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends ConsumerState<ChatBox> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(messageListNotifierProvider(widget.chatId).notifier)
          .loadMessages();

      scrollToEnd();
      ref
          .read(
            markSeenNotifierProvider({
              "userId": widget.myUserId,
              "chatId": widget.chatId,
            }).notifier,
          )
          .markSeen();
    });
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Pass the chatId to watch the family provider
    final messageState = ref.watch(messageListNotifierProvider(widget.chatId));

    // ✅ Listen for errors (optional, you can also handle loading differently)
    ref.listen<AsyncValue<List<MessageModelResModel>>>(
      messageListNotifierProvider(widget.chatId),
      (previous, next) {
        next.whenOrNull(
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
      },
    );

    return Expanded(
      child: messageState.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          reverse: false,
          controller: controller,
          itemBuilder: (context, index) {
            return Column(
              children: [
                index == 0 ? SizedBox(height: 5) : SizedBox(height: 2),
                (data[index].senderId != widget.myUserId)
                    ? ChatReceiveCard(
                        text: data[index].text ?? "",
                        time: data[index].createdAt ?? "",
                      )
                    : ChatSendCard(
                        text: data[index].text ?? "",
                        time: data[index].createdAt ?? "",
                      ),
              ],
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}

class ChatReceiveCard extends StatelessWidget {
  const ChatReceiveCard({super.key, required this.text, required this.time});
  final String text;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: MyColors.chatBoxColor(context),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: MyRegularText(
                  text: text,
                  fontSize: 18,
                  color: MyColors.textColor(context),
                ),
              ),
              MyRegularText(
                text: Utils.formatChatTime(time),
                fontSize: 14,
                color: MyColors.hintColor(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatSendCard extends StatelessWidget {
  const ChatSendCard({super.key, required this.text, required this.time});
  final String text;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 5,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: MyColors.chatBoxColor(context),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: MyRegularText(
                  text: text,
                  fontSize: 18,
                  color: MyColors.textColor(context),
                ),
              ),
              MyRegularText(
                text: Utils.formatChatTime(time),
                fontSize: 14,
                color: MyColors.hintColor(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatScreenAppBarSection extends StatelessWidget {
  const ChatScreenAppBarSection({
    super.key,
    required this.profile,
    required this.userId,
    required this.name,
  });
  final String userId;
  final String profile;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.bottomBarColor(context),
      padding: const EdgeInsets.fromLTRB(0, 8, 5, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: MyColors.constTheme,
                ),
              ),
              StoryCircularCard(
                size: 45,
                imageUrl: profile,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryScreen(userId: userId),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBoldText(
                    text: name,
                    color: MyColors.textColor(context),
                    fontSize: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: MyColors.constOrg,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      MyRegularText(
                        text: 'Online',
                        fontSize: 14,
                        color: MyColors.textLightColor(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: MyColors.constTheme),
          ),
        ],
      ),
    );
  }
}
