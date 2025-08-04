import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode inputFocusNode;
  const InputFieldWidget({
    required this.inputFocusNode,
    required this.controller,
    super.key});

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      // keeps the phone keyboard from appearing
      focusNode: widget.inputFocusNode,
      readOnly: true,
      showCursor: true,
      enableInteractiveSelection: true,

      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '0',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }
}