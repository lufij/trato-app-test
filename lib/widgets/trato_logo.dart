import 'package:flutter/material.dart';

class TratoLogo extends StatelessWidget {
  final double? size;
  final bool showText;
  final Color? backgroundColor;
  final Color? textColor;

  const TratoLogo({
    super.key,
    this.size,
    this.showText = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 40;
    final bgColor = backgroundColor ?? const Color(0xFFF5A623); // Color naranja del logotipo
    final txtColor = textColor ?? Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              't',
              style: TextStyle(
                fontSize: logoSize * 0.6,
                fontWeight: FontWeight.bold,
                color: txtColor,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'TRATO',
            style: TextStyle(
              fontSize: logoSize * 0.5,
              fontWeight: FontWeight.bold,
              color: txtColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

// Widget para usar solo el ícono circular
class TratoIcon extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  const TratoIcon({
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 40;
    final bgColor = backgroundColor ?? const Color(0xFFF5A623);
    final iColor = iconColor ?? Colors.white;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          't',
          style: TextStyle(
            fontSize: iconSize * 0.6,
            fontWeight: FontWeight.bold,
            color: iColor,
            fontFamily: 'Arial',
          ),
        ),
      ),
    );
  }
}
