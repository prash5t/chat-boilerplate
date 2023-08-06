import 'dart:developer';
import 'package:flutter/foundation.dart';

debugLog(String data) {
  if (kDebugMode) {
    log(data.toString());
  }
}
