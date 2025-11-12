import 'package:dating_app/presentation/components/my_input.dart';
import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyMessagesScreen extends StatelessWidget {
  const MyMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Column(
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
                    MyMessageActivitySection(),
                    MyMessageChatsSection(),
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

class MyMessageChatsSection extends StatelessWidget {
  const MyMessageChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                ChatUserCard(onClick: () {}, onStoryClick: () {}),
          ),
        ],
      ),
    );
  }
}

class ChatUserCard extends StatelessWidget {
  const ChatUserCard({
    super.key,
    required this.onStoryClick,
    required this.onClick,
  });
  final VoidCallback onStoryClick;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            StoryCircularCard(size: 55, onClick: () => onStoryClick()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBoldText(
                        text: 'Emma',
                        color: MyColors.textColor(context),
                        fontSize: 16,
                        textAlign: TextAlign.center,
                      ),
                      MyRegularText(
                        text: '23 min',
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
                        text: 'Hii',
                        color: MyColors.textColor(context),
                        fontSize: 15,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: MyColors.constTheme,
                        ),
                        height: 22,
                        width: 22,
                        child: MyBoldText(
                          text: '10',
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

class MyMessageActivitySection extends StatelessWidget {
  const MyMessageActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  right: 12.0,
                  left: index == 0 ? 20 : 0,
                ),
                child: index == 0
                    ? MyStoryCard(onStoryClick: () {}, onStoryAddClick: () {})
                    : StoryCard(),
              ),
            ),
          ),
        ],
      ),
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
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 2,
      children: [
        StoryCircularCard(size: 60, onClick: () {}),
        MyBoldText(
          text: 'Emma',
          color: MyColors.textColor(context),
          fontSize: 16,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MyStoryCard extends StatelessWidget {
  const MyStoryCard({
    super.key,
    required this.onStoryClick,
    required this.onStoryAddClick,
  });
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
              child: StoryCircularCard(size: 65, onClick: () => onStoryClick()),
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
    required this.onClick,
  });
  final double size;
  final double border;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [
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
            child: Image.asset(
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
