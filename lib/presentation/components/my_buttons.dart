import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onClick,
    this.enabled = true,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onClick;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Color(0xFF151515) : Color(0xFFc4c4c4),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: enabled && !isLoading ? onClick : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          alignment: AlignmentGeometry.center,
          padding: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: MyColors.constTheme,
            borderRadius: BorderRadius.circular(15),
            border: null,
          ),
          child: isLoading
              ? SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : MyBoldText(text: text, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  const MyIconButton({super.key, required this.icon, required this.onClick});

  final String icon;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.all(color: MyColors.borderColor(context)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(icon, width: 30, height: 30),
        ),
      ),
    );
  }
}

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {Navigator.pop(context)},
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.all(color: MyColors.borderColor(context)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(Icons.arrow_back_ios_new, color: MyColors.constTheme),
        ),
      ),
    );
  }
}
