import 'package:flutter/material.dart';

final gradDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
    Colors.teal,
    Colors.teal.withOpacity(0.8),
    Colors.teal.withOpacity(0.6)
  ]),
);
