import 'package:flutter/material.dart';
import '/style/theme.dart';
import '/ui/splash.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Quiz dinamico',
      theme: AppTheme.apTheme,
      home: Splash(),
    ),
  );
}
