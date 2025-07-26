import 'package:calculatorapp/widgets/buttons.dart';
import 'package:flutter/material.dart';
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

  final List buttonNames = [
    '(', ')', 'ANS', '%',
    '7', '8', '9', '/',
    '6', '5', '4', 'x',
    '3', '2', '1', '-',
    '.', '0', '=', '+',
  ];
  final List operators = [
    '/', 'x', '-', '+',
  ];
  final List specialCharacters = [
    '(', ')', 'ANS', '%',
  ];

  void calculatorButtonPressed (index) {
    final text = _controllerInput.text;
    final int cursorPosition = _controllerInput.selection.baseOffset;
    final newText = buttonNames[index];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
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
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // the user input field
              child: TextField(
                controller: _controllerInput,
                // keeps the phone keyboard from appearing
                focusNode: _inputFocusNode,
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
                    child: Icon(
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
                      child: Icon(Icons.backspace, color: Colors.red,)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // creates the calculator buttons
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: buttonNames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8
                  ),
                  itemBuilder: (context, index) {
                    // makes the operator buttons white
                    if (operators.contains(buttonNames[index])) {
                      return CalculatorButton(
                        buttonName: buttonNames[index],
                        buttonColor: Colors.white,
                        buttonPressed: () => calculatorButtonPressed(index)

                      );
                    }
                    // makes the special characters buttons blue
                    else if (specialCharacters.contains(buttonNames[index])) {
                      return CalculatorButton(
                        buttonName: buttonNames[index],
                        characterColor: Colors.white,
                        buttonColor: Colors.lightBlueAccent,
                        buttonPressed: () => calculatorButtonPressed(index)
                      );
                    }
                    // makes the equals button green
                    else {
                      return CalculatorButton(
                        buttonName: buttonNames[index],
                        characterColor: Colors.white,
                        buttonColor: Colors.green.shade300,
                        buttonPressed: () {
                          if (buttonNames[index] == '=') {
                              equalPressed();
                          } else {
                            calculatorButtonPressed(index);
                          }
                        },
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

