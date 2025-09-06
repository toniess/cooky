import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TagsSection extends StatelessWidget {
  final String tags;

  const TagsSection({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.tag, color: AppColors.accentBrown, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Tags',
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralGrayDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            tags,
            style: AppTextStyles.body(context).copyWith(
              fontSize: 16,
              color: AppColors.accentBrownDark,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
