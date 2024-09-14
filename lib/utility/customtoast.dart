import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required String title,
  required String message,
  required String type,
}){

  ToastificationType toastificationType;
  IconData icon;
  Color primaryColor;
  Color backgroundColor;
  Color foregroundColor;

  switch(type.toLowerCase()){
    case 'warning':
      toastificationType = ToastificationType.warning;
      icon = Icons.warning_rounded;
      primaryColor = Colors.orange;
      backgroundColor = Colors.orangeAccent;
      foregroundColor = Colors.orange;
      break;
    case 'success':
      toastificationType = ToastificationType.success;
      icon = Icons.check;
      primaryColor = Colors.green;
      backgroundColor = Colors.greenAccent;
      foregroundColor = Colors.black;
      break;
    case 'error':
      toastificationType = ToastificationType.error;
      icon = Icons.error_outlined;
      primaryColor = Colors.red;
      backgroundColor = Colors.redAccent;
      foregroundColor = Colors.black;
      break;
    default:
      icon = Icons.error_outlined;
      primaryColor = Colors.red;
      backgroundColor = Colors.redAccent;
      foregroundColor = Colors.black;
      toastificationType = ToastificationType.info;
      break;
  }

  toastification.show(
    context: context,
    type: toastificationType,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
    description: RichText(text: TextSpan(text: message)),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child){
      return FadeTransition(opacity: animation, child: child,);
    },
    icon: Icon(icon),
    primaryColor: primaryColor,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: false,
    applyBlurEffect: true,
  );
}