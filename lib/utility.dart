import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utility {
  static void showLoadingDialog() async {
    if (Get.isDialogOpen == true) {
      Utility.closeDialog();
    }
    await Get.dialog<void>(
      WillPopScope(
        onWillPop: () async => false,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            // decoration: Styles.cardDecoration,
            padding: const EdgeInsets.all(12),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }
}
