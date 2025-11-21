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
  const StoryShimmerLy({super.key, this.vertical = 0, this.horizontal = 0});

  final double vertical;
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 1500),

        baseColor: MyColors.shimmerBaseColor(context),

        highlightColor: MyColors.shimmerHighlightedColor(context),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
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
              width: 20,
              height: 5,
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerColor(context),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
