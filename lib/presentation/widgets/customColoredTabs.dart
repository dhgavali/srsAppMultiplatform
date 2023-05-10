import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColoredTab extends StatelessWidget {
  final String text;
  final Color selectedColor;
  final Color unselectedColor;
  final bool isSelected;

  const ColoredTab({
    Key? key,
    required this.text,
    required this.selectedColor,
    required this.unselectedColor,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : unselectedColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.black : Colors.black45),
      ),
    );
  }
}
