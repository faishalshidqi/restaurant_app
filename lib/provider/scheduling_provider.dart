import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/background_service.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRecommendation(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Recommendation Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
          //TODO: Ganti lagi jangan lupa
          const Duration(hours: 24),
          1,
          BackgroundService.callback,
          startAt: /*DateTimeHelper.format()*/ DateTime.now(),
          exact: true,
          wakeup: true);
    } else {
      print('Scheduling Recommendation Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
