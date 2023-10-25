import 'dart:isolate';
import 'dart:ui';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService.internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService.internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().getRestaurants();

    print('Alarm Fired');
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);
    print(result.restaurants);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
