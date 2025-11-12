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
              vertical: 14,
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
              vertical: 14,
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

class EndIconInputField extends StatefulWidget {
  const EndIconInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onRead = false,
    this.maxLine = 1,
    this.maxLength = -1,
    this.digitOnly = false,
    required this.onEndIconClick,
  });

  final TextEditingController controller;
  final String hintText;
  final bool onRead;
  final int maxLine;
  final int maxLength;
  final bool digitOnly;
  final Future<String> Function()
  onEndIconClick; // 👈 Change: return String (can be async)

  @override
  State<EndIconInputField> createState() => _EndIconInputFieldState();
}

class _EndIconInputFieldState extends State<EndIconInputField> {
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
          decoration: InputDecoration(
            counterText: '',
            label: MyRegularText(
              text: widget.hintText,
              color: MyColors.hintColor(context),
              fontSize: 18,
            ),
            filled: true,
            fillColor: MyColors.background(context),
            suffixIcon: IconButton(
              onPressed: () async {
                // 👇 Call function and get text
                final resultText = await widget.onEndIconClick();
                // 👇 Set text in controller
                setState(() {
                  widget.controller.text = resultText;
                });
              },
              icon: Icon(
                Icons.calendar_month,
                size: 20,
                color: MyColors.hintColor(context),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
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

class MyDropdown extends StatefulWidget {
  const MyDropdown({
    super.key,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.initialValue,
  });
  final String hint;
  final String? initialValue;
  final List<String> options;
  final Function(String selected) onSelected;
  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      isExpanded: true,
      initialValue: widget.initialValue,
      style: TextStyle(
        color: MyColors.textColor(context),
        fontFamily: 'sk',
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: MyColors.hintColor(context),
          fontFamily: 'sk',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        labelStyle: TextStyle(
          color: MyColors.hintColor(context),
          fontFamily: 'sk',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
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
      icon: Icon(
        Icons.arrow_drop_down_outlined,
        color: MyColors.hintColor(context),
      ),
      items: widget.options
          .map(
            (gender) =>
                DropdownMenuItem<String>(value: gender, child: Text(gender)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = value;
          widget.onSelected(selectedGender!);
        });
      },
    );
  }
}

class MySearchField extends StatefulWidget {
  const MySearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.onRead = false,
    this.maxLine = 1,
    this.maxLength = -1,
    this.digitOnly = false,
    this.icon = "assets/images/search.png",
  });

  final TextEditingController controller;
  final String hintText;
  final String icon;
  final String? labelText;
  final bool onRead;
  final int maxLine;
  final int maxLength;
  final bool digitOnly;

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
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
            hint: MyRegularText(
              text: widget.hintText,
              color: MyColors.hintColor(context),
              fontSize: 18,
            ),
            filled: true,
            fillColor: MyColors.background(context),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 10,
              ), // 👈 your custom padding
              child: Image.asset(
                widget.icon,
                height: 22,
                width: 22,
                color: MyColors.hintColor(context),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ), // 👈 ensures padding isn't overridden
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
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

class MyChatInputField extends StatelessWidget {
  const MyChatInputField({
    super.key,
    required this.controller,
    required this.hintText,
  });
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextField(
          controller: controller,
          style: TextStyle(
            fontFamily: 'sk',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: MyColors.textColor(context),
          ),
          minLines: 1,
          maxLines: 10,
          cursorColor: MyColors.hintColor(context),
          decoration: InputDecoration(
            counterText: '',
            hint: MyRegularText(
              text: hintText,
              color: MyColors.hintColor(context),
              fontSize: 18,
            ),
            filled: true,
            fillColor: MyColors.chatBoxColor(context),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: MyColors.chatBoxColor(context),
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: MyColors.chatBoxColor(context),
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: MyColors.chatBoxColor(context),
                width: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyMultiSelectDropdown extends StatefulWidget {
  const MyMultiSelectDropdown({
    super.key,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.initialValues,
  });

  final String hint;
  final List<String> options;
  final List<String>? initialValues;
  final Function(List<String> selected) onSelected;

  @override
  State<MyMultiSelectDropdown> createState() => _MyMultiSelectDropdownState();
}

class _MyMultiSelectDropdownState extends State<MyMultiSelectDropdown> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedItems = List.from(widget.initialValues!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final results = await showDialog<List<String>>(
          context: context,
          builder: (_) => _MultiSelectDialog(
            options: widget.options,
            initiallySelected: selectedItems,
          ),
        );

        if (results != null) {
          setState(() => selectedItems = results);
          widget.onSelected(selectedItems);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: MyColors.hintColor(context),
            fontFamily: 'sk',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedItems.isEmpty ? widget.hint : selectedItems.join(', '),
                style: TextStyle(
                  color: selectedItems.isEmpty
                      ? MyColors.hintColor(context)
                      : MyColors.textColor(context),
                  fontFamily: 'sk',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: MyColors.hintColor(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  const _MultiSelectDialog({
    required this.options,
    required this.initiallySelected,
  });

  final List<String> options;
  final List<String> initiallySelected;

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Options'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.options.map((option) {
            return CheckboxListTile(
              value: tempSelected.contains(option),
              title: Text(option),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    tempSelected.add(option);
                  } else {
                    tempSelected.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, tempSelected),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
