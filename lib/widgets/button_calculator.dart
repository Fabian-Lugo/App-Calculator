import 'package:flutter/material.dart';
import 'package:test_02/utils/color.dart';

class ButtonCalculator extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final VoidCallback onTap;
  final bool isDouble;
  final bool fullHeight;
  final bool borderOperator;
  final bool shadowOperator;

  const ButtonCalculator({
    super.key, 
    required this.text, 
    required this.onTap,
    required this.textColor,
    required this.buttonColor,
    this.isDouble = false,  
    this.fullHeight = false,
    this.borderOperator = false,
    this.shadowOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isDouble ? 2 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: fullHeight ? 100 : 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderOperator ? ColorApp.color_9 : ColorApp.color_1, 
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowOperator ? ColorApp.color_6 : ColorApp.color_9,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
        ),
      ),
    );
  }
}