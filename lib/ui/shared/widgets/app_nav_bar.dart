import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final String title;
  final VoidCallback onPressedBack;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final bool showBackButton;
  final double height;
  final EdgeInsets padding;

  const AppNavBar({
    super.key,
    required this.title,
    required this.onPressedBack,
    this.backgroundColor,
    this.textStyle,
    this.iconColor,
    this.showBackButton = true,
    this.height = 42,
    this.padding = const EdgeInsets.only(left: 30, right: 30, top: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      color: backgroundColor,
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: onPressedBack,
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: iconColor ?? Colors.black87,
              ),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}