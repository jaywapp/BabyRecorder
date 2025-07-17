import 'dart:ui';
import 'package:flutter/material.dart';

const normalFontSize = 20.0;

Widget BuildSectionTitle(String title, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide.none,
        bottom: BorderSide(color: color, width: 2),
      ),
    ),
    child: Text(
      title,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color),
      textAlign: TextAlign.left,
    ),
  );
}
