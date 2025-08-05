import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool showPercentage;
  final TextStyle? textStyle;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.size = 50.0,
    this.strokeWidth = 4.0,
    this.progressColor = AppColors.primary,
    this.backgroundColor = AppColors.outline,
    this.showPercentage = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeCap: StrokeCap.round,
          ),
          if (showPercentage)
            Center(
              child: Text(
                '$percentage%',
                style: textStyle ??
                    TextStyle(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}