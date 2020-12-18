import 'package:flutter/material.dart';
import 'colors.dart';
import 'constants.dart';

const themeFieldHeaderTextStyle = TextStyle(color: themeTextColor, fontSize: 30.0);

const themeFieldLabelTextStyle = TextStyle(color: themeTextColor, fontSize: 20.0);

final themeFieldContentTextStyle = TextStyle(color: themeTextColor, fontSize: 16.0);

final themeButtonTextStyle = TextStyle(color: themeDarkTextColor, fontSize: 16.0);

final themeSecondaryButtonStyle = TextStyle(color: themeAccentColor, fontSize: 20.0);

final themeFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: themeBorderColor),
    borderRadius: BorderRadius.circular(themeDefaultRadius));

final themeFieldErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: themeErrorColor),
    borderRadius: BorderRadius.circular(themeDefaultRadius));

InputDecoration createInputDecoration({String hint}) => InputDecoration(
    border: InputBorder.none,
    disabledBorder: InputBorder.none,
    enabledBorder: themeFieldBorder,
    focusedBorder: themeFieldBorder,
    errorBorder: themeFieldErrorBorder,
    focusedErrorBorder: themeFieldErrorBorder,
    errorStyle: TextStyle(fontSize: 16.0, color: themeErrorColor),
    hintText: hint ?? "",
    contentPadding: EdgeInsets.only(left: 16),
    fillColor: themeFieldColor,
    filled: true);
