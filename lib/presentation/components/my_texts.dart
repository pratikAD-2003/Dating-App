import 'package:flutter/material.dart';

class MyRegularText extends StatelessWidget {
  const MyRegularText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 16,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
  });

  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'sk',
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        decoration: textDecoration,
      ),
      textAlign: textAlign,
    );
  }
}

class MyBoldText extends StatelessWidget {
  const MyBoldText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 24,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.maxLine = 1,
    this.textOverflow = TextOverflow.ellipsis,
  });

  final String text;
  final Color color;
  final double fontSize;
  final int maxLine;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'sk',
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        decoration: textDecoration,
      ),
      maxLines: maxLine,
      textAlign: textAlign,
      overflow: textOverflow,
    );
  }
}
