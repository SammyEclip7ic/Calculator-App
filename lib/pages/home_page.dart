import 'package:calculatorapp/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:calculatorapp/classes/calculator_buttons.dart';
import 'package:calculatorapp/widgets/gridview_builder.dart';
import 'package:math_expressions/math_expressions.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // to store the last result for the 'ANS' button to utilize
  String _lastResult = '';

  final FocusNode _inputFocusNode = FocusNode();

  final TextEditingController _controllerInput = TextEditingController();
  final TextEditingController _controllerResult = TextEditingController();

  // Get the buttons list from the CalculatorButtons class.
  List _allButtons = CalculatorButtons().allButtons;

  void calculatorButtonPressed (index) {
    final text = _controllerInput.text;
    final int cursorPosition = _controllerInput.selection.baseOffset;
    final newText = _allButtons[index];

    if (cursorPosition < 0) {
      _controllerInput.text += newText;
      _controllerInput.selection = TextSelection.collapsed(
          offset: _controllerInput.text.length);
    } else {
      // insert the pressed button character at the cursor's position
        final updatedText = text.replaceRange(
            cursorPosition, cursorPosition, newText);
        _controllerInput.text = updatedText;
        _controllerInput.selection = TextSelection.collapsed(
            offset: (cursorPosition + newText.length).toInt());
    }
  }

  void _deleteChar() {
    final text = _controllerInput.text;
    final cursorPos = _controllerInput.selection.baseOffset;

    if (cursorPos > 0) {
      final newText = text.substring(0, cursorPos - 1) + text.substring(cursorPos);
      _controllerInput.text = newText;

      // Move cursor back by 1
      _controllerInput.selection = TextSelection.collapsed(offset: cursorPos - 1);
    }
  }

  void equalPressed() {
    String finalExpression = _controllerInput.text;

    // Exit early to avoid parsing empty input
    if (finalExpression.isEmpty) {
      return;
    }

    finalExpression = finalExpression.replaceAll('x', '*');
    finalExpression = finalExpression.replaceAll('ANS', _lastResult);

    try {
      ShuntingYardParser p = ShuntingYardParser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _controllerResult.text = eval.toString();
        _lastResult = eval.toString();
      });
    } catch (e) {
      setState(() {
        _controllerResult.text = 'Error';
      });
    }
  }

  @override
  void dispose() {
    _controllerInput.dispose();
    _controllerResult.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        backgroundColor: Colors.green.shade300,
        leading: Icon(Icons.calculate),
        ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // the user input field
              child: InputFieldWidget(
                inputFocusNode: _inputFocusNode, 
                controller: _controllerInput
                ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
              // the text field that shows the result of the calculation
              child: TextField(
                readOnly: true,
                controller: _controllerResult,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Result',

                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // The clear button - clears out the input field
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        // to erase the input
                        _controllerInput.clear();
                        _controllerResult.clear();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 24
                    )
                ),

                // The backspace button - clears a digit from the input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _deleteChar();
                        });
                      },
                      child: const Icon(Icons.backspace, color: Colors.red,)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // Creates the calculator buttons
              child: GridviewBuilderWidget(
                equalPressed: equalPressed, 
                calculatorButtonPressed: calculatorButtonPressed),
            )
          ],
        ),
      ),
    );
  }
}

