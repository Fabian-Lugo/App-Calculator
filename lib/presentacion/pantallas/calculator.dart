import 'package:flutter/material.dart';
import 'package:test_02/utils/color.dart';
import 'package:test_02/widgets/button_calculator.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  final List<String> symbols = ['Ac', '⌫', '÷', 'x', '-', '+', '=', '.'];
  String userInput = '0';
  String result = '0';

  void numbersScreen(String text) {
    setState(() {
      if (text == 'Ac') {
        userInput = '0';
        result = '0';
      } else if (text == '⌫') {
        if (userInput.length > 1) {
          userInput = userInput.substring(0, userInput.length - 1);
        } else {
          userInput = '0';
        }
      } else if (text == '=') {
        try {
          String finalOperation = userInput.replaceAll('x', '*');
          finalOperation = finalOperation.replaceAll('÷', '/');

          Parser p = Parser();
          Expression exp = p.parse(finalOperation);

          ContextModel cm = ContextModel();
          double evaluation = exp.evaluate(EvaluationType.REAL, cm);
          setState(() {
            result = userInput;
            userInput = evaluation.toString();

            if (userInput.endsWith('.0')) {
              userInput = userInput.substring(0, userInput.length - 2);
            }
          });
        } catch (e) {
          result = 'Error';
        }
      } else {
        List<String> listOperators = ['÷', 'x', '-', '+', '.'];
        String lastCharacter = userInput.substring(userInput.length - 1);

        bool newOperator = listOperators.contains(text);
        bool lastOperator = listOperators.contains(lastCharacter);
        if (newOperator && lastOperator) {
          userInput = userInput.substring(0, userInput.length - 1) + text;
        } else {
          if (userInput == '0' && !newOperator) {
            userInput = text;
          } else {
            userInput += text;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalculatorScreenBody(
        userInput: userInput,
        result: result,
        numbers: numbers,
        symbols: symbols,
        onPadTap: numbersScreen,
      ),
    );
  }
}

/// Full-screen gradient, padding, and centered calculator card.
class CalculatorScreenBody extends StatelessWidget {
  const CalculatorScreenBody({
    super.key,
    required this.userInput,
    required this.result,
    required this.numbers,
    required this.symbols,
    required this.onPadTap,
  });

  final String userInput;
  final String result;
  final List<String> numbers;
  final List<String> symbols;
  final void Function(String text) onPadTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CalculatorGradientBackdrop(
      width: size.width,
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorShellCard(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CalculatorKeypadColumn(
                  userInput: userInput,
                  result: result,
                  numbers: numbers,
                  symbols: symbols,
                  onPadTap: onPadTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorGradientBackdrop extends StatelessWidget {
  const CalculatorGradientBackdrop({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorApp.color_1,
            ColorApp.color_7,
          ],
        ),
      ),
      child: child,
    );
  }
}

/// Frosted panel with border wrapping the keypad.
class CalculatorShellCard extends StatelessWidget {
  const CalculatorShellCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: 350,
      decoration: BoxDecoration(
        border: Border.all(color: ColorApp.color_4, width: 2),
        borderRadius: BorderRadius.circular(20),
        color: ColorApp.color_3,
      ),
      child: child,
    );
  }
}

/// Result line, expression line, and all calculator rows.
class CalculatorKeypadColumn extends StatefulWidget {
  const CalculatorKeypadColumn({
    super.key,
    required this.userInput,
    required this.result,
    required this.numbers,
    required this.symbols,
    required this.onPadTap,
  });

  final String userInput;
  final String result;
  final List<String> numbers;
  final List<String> symbols;
  final void Function(String text) onPadTap;

  @override
  State<CalculatorKeypadColumn> createState() => _CalculatorKeypadColumnState();
}

class _CalculatorKeypadColumnState extends State<CalculatorKeypadColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CalculatorExpressionDisplay(
          result: widget.result,
          userInput: widget.userInput,
        ),
        const SizedBox(height: 15),
        CalculatorTopActionsRow(
          symbols: widget.symbols,
          onPadTap: widget.onPadTap,
        ),
        const SizedBox(height: 15),
        CalculatorSecondRow(
          numbers: widget.numbers,
          symbols: widget.symbols,
          onPadTap: widget.onPadTap,
        ),
        const SizedBox(height: 15),
        CalculatorNumpadBlock(
          numbers: widget.numbers,
          symbols: widget.symbols,
          onPadTap: widget.onPadTap,
        ),
      ],
    );
  }
}

class CalculatorExpressionDisplay extends StatelessWidget {
  const CalculatorExpressionDisplay({
    super.key,
    required this.result,
    required this.userInput,
  });

  final String result;
  final String userInput;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          result,
          style: const TextStyle(color: ColorApp.color_2, fontSize: 25),
          maxLines: 1,
        ),
        Text(
          userInput,
          style: const TextStyle(color: Colors.black, fontSize: 60),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CalculatorTopActionsRow extends StatelessWidget {
  const CalculatorTopActionsRow({
    super.key,
    required this.symbols,
    required this.onPadTap,
  });

  final List<String> symbols;
  final void Function(String text) onPadTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonCalculator(
          text: symbols[0],
          onTap: () => onPadTap(symbols[0]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: symbols[1],
          onTap: () => onPadTap(symbols[1]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: symbols[2],
          onTap: () => onPadTap(symbols[2]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: symbols[3],
          onTap: () => onPadTap(symbols[3]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
      ],
    );
  }
}

class CalculatorSecondRow extends StatelessWidget {
  const CalculatorSecondRow({
    super.key,
    required this.numbers,
    required this.symbols,
    required this.onPadTap,
  });

  final List<String> numbers;
  final List<String> symbols;
  final void Function(String text) onPadTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonCalculator(
          text: numbers[7],
          onTap: () => onPadTap(numbers[7]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: numbers[8],
          onTap: () => onPadTap(numbers[8]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: numbers[9],
          onTap: () => onPadTap(numbers[9]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_3,
        ),
        ButtonCalculator(
          text: symbols[4],
          onTap: () => onPadTap(symbols[4]),
          textColor: ColorApp.color_7,
          buttonColor: ColorApp.color_8,
          borderOperator: true,
        ),
      ],
    );
  }
}

/// Left numpad (4–9, 0, dot) and right operator column (+, =).
class CalculatorNumpadBlock extends StatelessWidget {
  const CalculatorNumpadBlock({
    super.key,
    required this.numbers,
    required this.symbols,
    required this.onPadTap,
  });

  final List<String> numbers;
  final List<String> symbols;
  final void Function(String text) onPadTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  children: [
                    ButtonCalculator(
                      text: numbers[4],
                      onTap: () => onPadTap(numbers[4]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                    ButtonCalculator(
                      text: numbers[5],
                      onTap: () => onPadTap(numbers[5]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                    ButtonCalculator(
                      text: numbers[6],
                      onTap: () => onPadTap(numbers[6]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ButtonCalculator(
                      text: numbers[1],
                      onTap: () => onPadTap(numbers[1]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                    ButtonCalculator(
                      text: numbers[2],
                      onTap: () => onPadTap(numbers[2]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                    ButtonCalculator(
                      text: numbers[3],
                      onTap: () => onPadTap(numbers[3]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ButtonCalculator(
                      text: numbers[0],
                      onTap: () => onPadTap(numbers[0]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                      isDouble: true,
                    ),
                    ButtonCalculator(
                      text: symbols[7],
                      onTap: () => onPadTap(symbols[7]),
                      textColor: ColorApp.color_7,
                      buttonColor: ColorApp.color_3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ButtonCalculator(
                  text: symbols[5],
                  onTap: () => onPadTap(symbols[5]),
                  textColor: ColorApp.color_7,
                  buttonColor: ColorApp.color_8,
                  fullHeight: true,
                  borderOperator: true,
                ),
                const SizedBox(height: 15),
                ButtonCalculator(
                  text: symbols[6],
                  onTap: () => onPadTap(symbols[6]),
                  textColor: ColorApp.color_3,
                  buttonColor: ColorApp.color_6,
                  fullHeight: true,
                  borderOperator: true,
                  shadowOperator: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
