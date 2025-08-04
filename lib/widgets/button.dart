import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String buttonName;
  final Color? characterColor;
  final Color buttonColor;
  final buttonPressed;

  const CalculatorButton({
    required this.buttonName,
    this.characterColor,
    required this.buttonColor,
    required this.buttonPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: buttonPressed,
        style: TextButton.styleFrom(
          foregroundColor: characterColor,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
        child: Text(buttonName, style: TextStyle(fontSize: 24),),
    );
  }
}



