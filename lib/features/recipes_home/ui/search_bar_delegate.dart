import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.accentBrown,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.bottomCenter,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Поиск...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SearchBarDelegate oldDelegate) => false;
}
