import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key, this.dividerText = "", this.textSize = 16});
  final String dividerText;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.hintColor(context),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 0.6,
            width: double.infinity,
          ),
        ),
        MyRegularText(
          text: dividerText,
          color: MyColors.textColor(context),
          fontSize: textSize,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.hintColor(context),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 0.6,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
