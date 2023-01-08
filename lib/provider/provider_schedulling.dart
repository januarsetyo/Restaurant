import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Active');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Cancel');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
