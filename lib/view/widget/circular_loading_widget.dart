import 'package:flutter/material.dart';

class CircularLoadingWidget extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double size;
  final double strokeWidth;
  const CircularLoadingWidget({
    super.key,
    this.padding = EdgeInsets.zero,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = AlwaysStoppedAnimation<Color>(color ?? Colors.white);
    return SizedBox.square(
      dimension: size,
      child: Padding(
        padding: padding,
        child: CircularProgressIndicator(
          valueColor: valueColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
