import 'dart:convert';

import 'package:flutter/material.dart';

Container imageCircle(
  BuildContext context, {
  String image = '',
  double height = 150.0,
  double width = 150.0,
  double radius = 70.0,
  EdgeInsets? margin,
}) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    child: image != '' && image != 'null'
        ? CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[300],
            backgroundImage: Image.memory(base64Decode(image)).image//NetworkImage(image),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(width / 2)),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              'assets/vet.png',
              // color: Theme.of(context).accentColor,
            ),
          ),
  );
}
