import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassmorphicTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double borderRadius;
  final double blur;
  final double border;
  final double? width;
  final double? height;
  final ValueChanged<String>? onChanged;
  final bool enabled;



  const GlassmorphicTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hintStyle,
    this.textStyle,
    this.borderRadius = 30,
    this.blur = 15,
    this.border = 1,
    this.width,
    this.height,
    this.onChanged,
    this.enabled = true,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width ?? MediaQuery.of(context).size.width * 0.8,
      height: height ?? 60,
      borderRadius: borderRadius,
      blur: blur,


      alignment: Alignment.center,
      border: border,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.1),
          Color(0xFFFFFFFF).withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.5),
          Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(color: Colors.white.withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
        style: textStyle ?? TextStyle(color: Colors.white),
        cursorColor: Colors.white,
      ),
    );
  }
}
