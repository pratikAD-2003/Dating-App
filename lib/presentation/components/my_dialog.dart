import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    this.radius = 10,
    this.verticalPadding = 15,
    this.horizonalPadding = 20,
    this.title,
    this.subtitle,
    this.btn1Text,
    this.btn2Text,
    this.onBtn1Tap,
    this.onBtn2Tap,
  });

  final double radius;
  final double verticalPadding;
  final double horizonalPadding;
  final String? title;
  final String? subtitle;
  final String? btn1Text;
  final String? btn2Text;
  final VoidCallback? onBtn1Tap;
  final VoidCallback? onBtn2Tap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      backgroundColor: MyColors.bottomBarColor(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizonalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            if (title != null)
              MyBoldText(
                text: title!,
                color: MyColors.textColor(context),
                fontSize: 18,
              ),
            if (subtitle != null) ...[
              MyRegularText(
                text: subtitle!,
                color: MyColors.textLight2Color(context),
                fontSize: 16,
              ),
            ],
            if (btn1Text != null || btn2Text != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  if (btn1Text != null)
                    TextButton(
                      onPressed: onBtn1Tap ?? () => Navigator.pop(context),
                      child: MyBoldText(
                        text: btn1Text!,
                        fontSize: 16,
                        color: MyColors.textColor(context),
                      ),
                    ),
                  if (btn2Text != null)
                    TextButton(
                      onPressed: onBtn2Tap ?? () => Navigator.pop(context),
                      child: MyBoldText(
                        text: btn2Text!,
                        fontSize: 16,
                        color: MyColors.textColor(context),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
