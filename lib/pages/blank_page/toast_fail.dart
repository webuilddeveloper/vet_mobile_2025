import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastFail({
  String text = 'การเชื่อมต่อผิดพลาด',
  Color backgroundColor = Colors.grey,
  Color fontColor = Colors.white,
  int duration = 3,
  BuildContext? context,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: duration > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: fontColor,
    fontSize: 16.0,
    timeInSecForIosWeb: duration,
  );
}
