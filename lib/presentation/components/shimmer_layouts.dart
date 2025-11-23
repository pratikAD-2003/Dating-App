import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerLy extends StatelessWidget {
  const HomeShimmerLy({super.key, this.vertical = 10, this.horizontal = 25});

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),

      baseColor: MyColors.shimmerBaseColor(context),

      highlightColor: MyColors.shimmerHighlightedColor(context),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoryShimmerLy extends StatelessWidget {
  const StoryShimmerLy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 1500),
        baseColor: MyColors.shimmerBaseColor(context),
        highlightColor: MyColors.shimmerHighlightedColor(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RequestMatchesShimmerLy extends StatelessWidget {
  const RequestMatchesShimmerLy({
    super.key,
    this.vertical = 0,
    this.horizontal = 0,
  });

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),

      baseColor: MyColors.shimmerBaseColor(context),

      highlightColor: MyColors.shimmerHighlightedColor(context),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: MyColors.shimmerContainerColor(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserDetailsShimmerLy extends StatelessWidget {
  const UserDetailsShimmerLy({
    super.key,
    this.vertical = 10,
    this.horizontal = 25,
  });

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),

      baseColor: MyColors.shimmerBaseColor(context),

      highlightColor: MyColors.shimmerHighlightedColor(context),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatUsersShimmerLy extends StatelessWidget {
  const ChatUsersShimmerLy({
    super.key,
    this.vertical = 10,
    this.horizontal = 20,
  });

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),

      baseColor: MyColors.shimmerBaseColor(context),

      highlightColor: MyColors.shimmerHighlightedColor(context),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MyColors.shimmerContainerColor(context),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                      color: MyColors.shimmerContainerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoryScreenShimmerLy extends StatelessWidget {
  const StoryScreenShimmerLy({
    super.key,
    this.vertical = 10,
    this.horizontal = 25,
  });

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),

      baseColor: MyColors.shimmerBaseColor(context),

      highlightColor: MyColors.shimmerHighlightedColor(context),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
