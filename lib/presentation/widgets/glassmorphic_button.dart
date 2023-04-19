import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassmorphicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double borderRadius;
  final double blur;
  final double border;
  final double? width;
  final double? height;

  const GlassmorphicButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.borderRadius = 30,
    this.blur = 15,
    this.border = 1,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GlassmorphicContainer(
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        height: height ?? 50,
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
        child: Text(
          text,
          style: textStyle ?? TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
