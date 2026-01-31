import 'package:flutter/material.dart';

/// Main Popup Component Class
class AppPopup {
  /// Show a confirmation dialog with customizable actions
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    VoidCallback? onConfirm,
    Color? confirmColor,
    Color? cancelColor,
    bool barrierDismissible = true,
  }) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 18.0 : 20.0;
    final contentFontSize = screenWidth < 360 ? 13.0 : 15.0;
    final buttonFontSize = screenWidth < 360 ? 10.0 : 12.0;
    final effectiveConfirmColor = confirmColor ?? const Color(0xff539DF3);
    final effectiveCancelColor = cancelColor ?? const Color(0xff212121);

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xff212121),
              fontSize: titleFontSize,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: contentFontSize,
              color: const Color(0xFF323232),
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: Color(0xffE5E7EB), width: 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: effectiveCancelColor,
                        fontWeight: FontWeight.w500,
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (onConfirm != null) {
                        onConfirm();
                      }
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: effectiveConfirmColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
