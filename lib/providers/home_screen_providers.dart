import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final homeTitleTextStyleProvider = Provider<TextStyle>(
      (ref) => TextStyle(color: Colors.white, fontSize: 0.1.sw, fontWeight: FontWeight.bold),
);
