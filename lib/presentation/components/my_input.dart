import 'package:dating_app/presentation/components/my_texts.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyInputField extends StatefulWidget {
  const MyInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.onRead = false,
    this.maxLine = 1,
    this.maxLength = -1,
    this.digitOnly = false,
    required this.condition,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool onRead;
  final int maxLine;
  final int maxLength;
  final bool digitOnly;
  final bool Function(String text) condition;

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  late bool isMatchedCondition;

  @override
  void initState() {
    super.initState();
    // Initialize the condition once
    isMatchedCondition = widget.condition(widget.controller.text);

    // Listen for text changes
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final newCondition = widget.condition(widget.controller.text);
    if (newCondition != isMatchedCondition) {
      setState(() {
        isMatchedCondition = newCondition;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextField(
          controller: widget.controller,
          style: TextStyle(
            fontFamily: 'sk',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: MyColors.textColor(context),
          ),
          readOnly: widget.onRead,
          maxLines: widget.maxLine,
          maxLength: widget.maxLength != -1 ? widget.maxLength : 300,
          inputFormatters: [
            if (widget.digitOnly)
              FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
          ],
          cursorColor: MyColors.hintColor(context),
          decoration: InputDecoration(
            counterText: '',
            label: MyRegularText(
              text: widget.hintText,
              color: MyColors.hintColor(context),
              fontSize: 18,
            ),
            filled: true,
            fillColor: MyColors.background(context),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.check_circle,
                key: ValueKey(isMatchedCondition),
                size: 20,
                color: isMatchedCondition
                    ? MyColors.constTheme
                    : MyColors.hintColor(context),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.onRead = false,
    this.maxLine = 1,
    this.maxLength = -1,
    this.digitOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool onRead;
  final int maxLine;
  final int maxLength;
  final bool digitOnly;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextField(
          controller: widget.controller,
          style: TextStyle(
            fontFamily: 'sk',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: MyColors.textColor(context),
          ),
          readOnly: widget.onRead,
          maxLines: widget.maxLine,
          maxLength: widget.maxLength != -1 ? widget.maxLength : 300,
          inputFormatters: [
            if (widget.digitOnly)
              FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
          ],
          cursorColor: MyColors.hintColor(context),
          obscureText: !isVisible, // 👈 hides or shows password text
          decoration: InputDecoration(
            counterText: '',
            label: MyRegularText(
              text: widget.hintText,
              color: MyColors.hintColor(context),
              fontSize: 18,
            ),
            filled: true,
            fillColor: MyColors.background(context),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 24,
                  color: MyColors.hintColor(context),
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: MyColors.borderColor(context),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final FocusNode? previousNode;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextNode,
    this.previousNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(
          fontFamily: 'sk',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: MyColors.textColor(context),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        cursorColor: MyColors.hintColor(context),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: MyColors.background(context),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: MyColors.borderColor(context),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: MyColors.borderColor(context),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: MyColors.constTheme, width: 1.2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextNode != null) {
            FocusScope.of(context).requestFocus(nextNode);
          } else if (value.isEmpty && previousNode != null) {
            FocusScope.of(context).requestFocus(previousNode);
          }
        },
      ),
    );
  }
}
