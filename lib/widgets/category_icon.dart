import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/theme.dart';

class CategoryIcon extends StatelessWidget {
  final EventCategory category;
  final double size;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getIcon(),
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  String _getIcon() {
    switch (category) {
      case EventCategory.seminar:
        return '🎤';
      case EventCategory.exam:
        return '📝';
      case EventCategory.fest:
        return '🎉';
      case EventCategory.notice:
        return '📢';
    }
  }
}