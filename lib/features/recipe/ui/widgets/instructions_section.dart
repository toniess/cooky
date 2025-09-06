import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';

class InstructionsSection extends StatelessWidget {
  final String instructions;

  const InstructionsSection({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildInstructionsContent(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.menu_book, color: AppColors.accentBrown, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Instructions',
          style: AppTextStyles.heading(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.neutralGrayDark,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        instructions,
        style: AppTextStyles.body(
          context,
        ).copyWith(fontSize: 16, color: AppColors.accentBrownDark, height: 1.6),
      ),
    );
  }
}
