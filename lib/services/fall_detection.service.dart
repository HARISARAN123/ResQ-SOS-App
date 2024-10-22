// lib/services/fall_detection_service.dart
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class FallDetectionService {
  StreamSubscription? _accelerometerSubscription;
  Function(bool)? _fallDetectionCallback;

  void startFallDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Simple fall detection algorithm
      // You might want to implement a more sophisticated algorithm
      if (event.x.abs() > 20 || event.y.abs() > 20 || event.z.abs() > 20) {
        if (_fallDetectionCallback != null) {
          _fallDetectionCallback!(true);
        }
      }
    });
  }

  void stopFallDetection() {
    _accelerometerSubscription?.cancel();
  }

  void setFallDetectionCallback(Function(bool) callback) {
    _fallDetectionCallback = callback;
  }
}