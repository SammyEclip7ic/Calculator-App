import 'package:flutter/material.dart';
import 'package:calculatorapp/classes/calculator_buttons.dart';
import 'package:calculatorapp/widgets/button.dart';

class GridviewBuilderWidget extends StatelessWidget {
  final VoidCallback equalPressed;
  final void Function(int) calculatorButtonPressed;
  const GridviewBuilderWidget({
    required this.equalPressed,
    required this.calculatorButtonPressed, 
    super.key
    });

  @override
  Widget build(BuildContext context) {
    List _allButtons = CalculatorButtons().allButtons;
    List _operatorButtons = CalculatorButtons().operatorButtons;
    List _specialCharacterButtons = CalculatorButtons().specialCharacterButtons;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _allButtons.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8
      ),
      itemBuilder: (context, index) {
        // makes the operator buttons white
        if (_operatorButtons.contains(_allButtons[index])) {
          return CalculatorButton(
            buttonName: _allButtons[index],
            buttonColor: Colors.white,
            buttonPressed: () => calculatorButtonPressed(index)

          );
        }
        // makes the special characters buttons blue
        else if (_specialCharacterButtons.contains(_allButtons[index])) {
          return CalculatorButton(
            buttonName: _allButtons[index],
            characterColor: Colors.white,
            buttonColor: Colors.lightBlueAccent,
            buttonPressed: () => calculatorButtonPressed(index)
          );
        }
        // makes the equals button green
        else {
          return CalculatorButton(
            buttonName: _allButtons[index],
            characterColor: Colors.white,
            buttonColor: Colors.green.shade300,
            buttonPressed: () {
              if (_allButtons[index] == '=') {
                  equalPressed();
              } else {
                calculatorButtonPressed(index);
              }
            },
          );
        }
      }
    );
  }
}