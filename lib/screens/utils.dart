import 'package:flutter/material.dart';

Future<dynamic> constructDialog(BuildContext context, Widget widget) {
  return showDialog(context: context, builder: (context) => widget);
}
