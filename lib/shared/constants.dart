import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

InputDecoration textFieldDecoration(String text) {
  return InputDecoration(
    labelText: text,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(),
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

String dt(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
}

String d(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

const formPadding = EdgeInsets.fromLTRB(20.0, 0, 20.0, 0);
const formImageSpacer = SizedBox(height: 40.0);
const formTextSpacer = SizedBox(height: 20.0);
const formButtonSpacer = SizedBox(height: 5.0);
const formRowSpacer = SizedBox(height: 5.0);

const errorTextStyle = TextStyle(
  color: Colors.redAccent,
);

const awaitTimeout = Duration(seconds: 20);

const cameraResolution = ResolutionPreset.medium;

// All images older than the specified period is removed
const imageCacheRetentionPeriod = Duration(minutes: 9);
