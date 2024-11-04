import 'package:flutter/material.dart';

double ofScreenSize(double percentage, context) {
  return MediaQuery.of(context).size.width * percentage;
}
