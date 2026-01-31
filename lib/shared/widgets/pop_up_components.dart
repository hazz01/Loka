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
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
  }) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 16.0 : 18.0;
    final contentFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final buttonFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final effectiveConfirmColor = confirmColor ?? const Color(0xff366EDD);
    final effectiveCancelColor = cancelColor ?? const Color(0xff666666);

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
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? effectiveConfirmColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF132644),
                    fontSize: titleFontSize,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: contentFontSize,
              color: const Color(0xFF323232),
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: effectiveCancelColor,
                  fontWeight: FontWeight.w600,
                  fontSize: buttonFontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm();
                }
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveConfirmColor,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
          ],
        );
      },
    );
  }
}
