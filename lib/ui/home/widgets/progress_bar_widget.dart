import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final int current;
  final int total;
  final Color progressColor;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final bool showText;

  const ProgressBarWidget({
    super.key,
    required this.current,
    required this.total,
    this.progressColor = AppColors.background,
    this.backgroundColor = Colors.white24,
    this.textColor = AppColors.background,
    this.height = 6.0,
    this.showText = true,
  });

  double get progress => total > 0 ? current / total : 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showText) ...[
          Text(
            'Progress',
            style: TextStyle(
              color: textColor.withAlpha(179),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ),
              ),
            ),
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                '$current/$total',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}