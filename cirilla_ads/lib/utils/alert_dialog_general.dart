import 'package:cirilla/screens/screens.dart';
import 'package:flutter/material.dart';

Widget alertDialogGeneral({required BuildContext context, required String route}) {
  Widget child;
  Color? backgroundColor;
  double? elevation;
  EdgeInsets? insetPadding;
  switch (route) {
    case CouponReferralScreen.routeName:
      backgroundColor = Colors.transparent;
      elevation = 0;
      insetPadding = EdgeInsets.zero;
      child = const CouponReferralScreen(openPopup: true);
      break;
    default:
      child = Container();
  }

  return AlertDialog(
    insetPadding: insetPadding,
    backgroundColor: backgroundColor,
    elevation: elevation,
    content: child,
  );
}
