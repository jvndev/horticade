import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:intl/intl.dart';

InputDecoration textFieldDecoration(String text) {
  return InputDecoration(
    labelText: text,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(),
    ),
    labelStyle: const TextStyle(
      color: Colors.black,
    ),
    hintStyle: const TextStyle(
      color: Colors.orange,
    ),
  );
}

// firebase stored image name and ext.
String remoteImageFilename(String uid) {
  DateTime dt = DateTime.now();
  String dtStr =
      "${dt.year}${dt.month}${dt.day}${dt.hour}${dt.second}${dt.millisecond}";

  return "${uid}_$dtStr.jpg";
}

void toast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    textColor: HorticadeTheme.toastColor,
    backgroundColor: HorticadeTheme.toastBackgroundColor,
  );
}

String dt(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
}

String d(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String c(double val) => NumberFormat('R0.00').format(val);

const formPadding = EdgeInsets.fromLTRB(20.0, 0, 20.0, 0);
const formImageSpacer = SizedBox(height: 40.0);
const formTextSpacer = SizedBox(height: 20.0);
const formButtonSpacer = SizedBox(height: 5.0);
const formRowSpacer = SizedBox(height: 5.0);

const errorTextStyle = TextStyle(
  color: Colors.redAccent,
);

const awaitTimeout = Duration(seconds: 20);

const cameraResolution = ResolutionPreset.high;

// All images older than the specified period is removed
const imageCacheRetentionPeriod = Duration(days: 3);
