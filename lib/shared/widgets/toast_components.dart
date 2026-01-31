import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastNotification {
  static void success(BuildContext context, {required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
    );
  }

  static void error(BuildContext context, {required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
    );
  }

  static void warning(BuildContext context, {required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.warning,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
    );
  }

  static void info(BuildContext context, {required String message}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
    );
  }

  static void showSuccess(BuildContext context, {required String message}) {}
}
