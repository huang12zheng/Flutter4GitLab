import 'package:flutter/material.dart';

double getWidth(BuildContext context)  => MediaQuery.of(context).size.width;

double getHeidht(BuildContext context) => MediaQuery.of(context).size.height >= 775? MediaQuery.of(context).size.height: 775;

