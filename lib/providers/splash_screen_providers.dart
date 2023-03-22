import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final titleTextStyleProvider = Provider<TextStyle>(
      (ref) => TextStyle(color: Colors.deepPurple, fontSize :0.15.sw, fontWeight: FontWeight.bold),
);