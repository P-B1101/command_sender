import 'package:flutter/material.dart';
import 'package:overlay_app/model/cow_id.dart';
import 'package:overlay_app/view/widget/cow_id_popup.dart';
import 'package:overlay_app/view/widget/farm_id_popup.dart';

class PopUpController {
  const PopUpController._();

  static Future<String?> showVisitIdPopup(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.25),
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: FarmIdInputPopup(),
      ),
    );
    if (result is! String) return null;
    return result;
  }

  static Future<CowId?> showCowIdPopup({
    required BuildContext context,
    required String? rfId,
  }) async {
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.25),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CowIdInputPopup(rfId: rfId),
      ),
    );
    if (result is! CowId) return null;
    return result;
  }
}
