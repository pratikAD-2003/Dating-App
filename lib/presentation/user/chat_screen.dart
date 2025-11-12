import 'package:dating_app/presentation/bottom_nav/my_messages_screen.dart';
import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            ChatScreenAppBarSection(),
            ChatBox(),
            ChatInputSection(
              onText: (message) {
                debugPrint(message);
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

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        reverse: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              index == 9 ? SizedBox(height: 5) : SizedBox.shrink(),
              index % 2 == 0 ? ChatReceiveCard() : ChatSendCard(),
            ],
          );
        },
      ),
    );
  }
}

class ChatReceiveCard extends StatelessWidget {
  const ChatReceiveCard({super.key});

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
                  text: 'Hii\nIm Pratik yadav',
                  fontSize: 18,
                  color: MyColors.textColor(context),
                ),
              ),
              MyRegularText(
                text: '2:55 PM',
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
  const ChatSendCard({super.key});

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
                  text: 'Hii\nIm Pratik yadav',
                  fontSize: 18,
                  color: MyColors.textColor(context),
                ),
              ),
              MyRegularText(
                text: '2:55 PM',
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
  const ChatScreenAppBarSection({super.key});

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
              StoryCircularCard(size: 45, onClick: () {}),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyBoldText(
                    text: 'Emma Williams',
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
