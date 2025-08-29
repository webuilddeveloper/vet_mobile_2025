import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' ' + label,
        style: TextStyle(fontSize: 15.000, fontFamily: 'Kanit'),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 40.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      inputFormatters: [
        // new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9@_.]")),
        FilteringTextInputFormatter.deny(RegExp(r"\s")),
      ],
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF7090AC),
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w300,
          fontFamily: 'Kanit',
          fontSize: 15.00,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

textFieldNew(
  TextEditingController model,
  TextEditingController modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 45.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        labelText: hintText,
        labelStyle: TextStyle(
          color: Color(0xFF7090AC),
          fontWeight: FontWeight.w300,
          fontFamily: 'Kanit',
          fontSize: 15.00,
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        //   borderSide: BorderSide(width: 1, color: Color(0xFFD77E23)),
        // ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Color(0xFF7090AC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Color(0xFFB6B6B6)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
    ),
  );
}

textFieldLogin({
  required TextEditingController model,
  required String hintText,
  String labelText = '',
  bool enabled = true,
  bool isPassword = false,
  bool showVisibility = false,
  bool visibility = true,
  Function()? callback,
  Function(String)? onChanged,
}) {
  return SizedBox(
    height: 40.0,
    child: TextField(
      inputFormatters: [
        // new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9@_.]")),
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      // keyboardType: TextInputType.number,
      obscureText: isPassword ? visibility : false,
      controller: model,
      onChanged: (String value) {
        onChanged?.call(value);
      },
      enabled: enabled,
      cursorColor: Color(0xFF216DA6),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF7090AC),
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w300,
          fontFamily: 'Kanit',
          fontSize: 15.00,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

textFieldRegister({
  required TextEditingController model,
  required String hintText,
  bool enabled = true,
  bool isPassword = false,
  bool showVisibility = false,
  bool visibility = true,
  String labelText = "",
  Function()? callback,
  Function(String)? onChanged,
}) {
  return SizedBox(
    height: 40.0,
    child: TextField(
      inputFormatters: [
        // new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9@_.]")),
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      // keyboardType: TextInputType.number,
      obscureText: isPassword ? visibility : false,
      controller: model,
      onChanged: (String value) {
        onChanged?.call(value);
      },
      enabled: enabled,
      cursorColor: Color(0xFF216DA6),
      style: TextStyle(
        // color: Colors.white,
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF7090AC),
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w300,
          fontFamily: 'Kanit',
          fontSize: 15.00,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
