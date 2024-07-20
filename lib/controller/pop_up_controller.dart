import 'package:flutter/material.dart';
import 'package:overlay_app/view/widget/input_popup.dart';

class PopUpController {
  const PopUpController._();

  static Future<String?> showVisigIdPopup(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.08),
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: InputPopup(),
      ),
    );
    if (result is! String) return null;
    return result;
  }
}
