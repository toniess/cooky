import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.accentBrown),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Search for recipes',
          prefixIcon: Icon(Icons.search, color: AppColors.neutralGrayDark),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SearchBarDelegate oldDelegate) => false;
}
