import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const InfoChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class InfoChipsRow extends StatelessWidget {
  final String? category;
  final String? area;

  const InfoChipsRow({super.key, this.category, this.area});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (category != null && category!.isNotEmpty)
          InfoChip(
            label: category!,
            icon: Icons.category,
            color: AppColors.accentBrown,
          ),
        if (area != null && area!.isNotEmpty)
          InfoChip(
            label: area!,
            icon: Icons.location_on,
            color: AppColors.accentYellowDark,
          ),
      ],
    );
  }
}
