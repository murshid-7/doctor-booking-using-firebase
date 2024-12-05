import 'package:flutter/material.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';

class SnackBarWidget {
  void showSuccessSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: poppinsText(
          text: message,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color.fromARGB(255, 13, 77, 90),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: poppinsText(
          text: message,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
