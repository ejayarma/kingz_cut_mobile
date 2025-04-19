import 'package:flutter/material.dart';

class AppAlert {
  static final _snackBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  );

  static void snackBarErrorAlert(
    BuildContext context,
    String message, [
    duration = const Duration(seconds: 5),
  ]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: _snackBarShape,
      ),
    );
  }

  static void snackBarSuccessAlert(
    BuildContext context,
    String message, [
    duration = const Duration(seconds: 5),
  ]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: _snackBarShape,
      ),
    );
  }

  static void snackBarSuccessWithAction(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
    String actionLabel = 'Undo',
    required void Function() onPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: _snackBarShape,
        action: SnackBarAction(label: actionLabel, onPressed: onPressed),
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }

  static void snackBarInfoAlert(
    BuildContext context,
    String message, [
    duration = const Duration(seconds: 5),
  ]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: _snackBarShape,
      ),
    );
  }
}
