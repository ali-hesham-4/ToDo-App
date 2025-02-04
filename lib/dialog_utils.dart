import 'package:flutter/material.dart';
import 'package:to_do_application/Screens/HomeScreen.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(message),
                )
              ],
            ),
          );
        });
  }

  static void hideLoading({
    required BuildContext context,
  }) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
    BuildContext? navigatorContext, // Add this parameter
  }) {
    navigatorContext ??=
        context; // Use provided context or fallback to dialog context

    List<Widget> actions = [];

    // Add positive action button if defined
    if (posActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          // Call the provided posAction
          posAction?.call();

          // Close the dialog
          Navigator.pop(context);
        },
        child: Text(posActionName),
      ));
    }

    // Add negative action button if defined
    if (negActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          // Call the provided negAction
          negAction?.call();

          // Close the dialog
          Navigator.pop(context);
        },
        child: Text(negActionName),
      ));
    }

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(message),
          actions: actions,
        );
      },
    );
  }
}
