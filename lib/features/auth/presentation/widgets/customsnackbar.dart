import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color textColor,
  Color? backgroundColor,
}) {
  final theme = Theme.of(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
