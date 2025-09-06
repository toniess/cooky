import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading(BuildContext context) => Theme.of(
    context,
  ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold);

  static TextStyle body(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
}
