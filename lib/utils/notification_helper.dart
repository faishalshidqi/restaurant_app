import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurants.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  late int index;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants restaurants) async {
    //TODO: Hapus try catch
    try {
      var channelId = 'qwerty';
      var channelName = 'qwerty_channel';
      var channelDescription = 'Restaurant Recommendation Channel';

      var restaurantList = await ApiService().getRestaurants();
      var restaurants = restaurantList.restaurants;
      var randomIndex = Random().nextInt(restaurants.length);
      index = randomIndex;
      var randomRestaurant = restaurants[index];

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelId, channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          styleInformation: const DefaultStyleInformation(true, true));
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      var titleNotification = "<b>Rekomendasi Restoran Untukmu</b>";
      var bodyNotification = randomRestaurant.name;

      await flutterLocalNotificationsPlugin.show(
          0, titleNotification, bodyNotification, platformChannelSpecifics,
          payload: json.encode(restaurantList.toJson()));
    } catch (error) {
      print(error);
    }
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) {
      var data = Restaurants.fromJson(json.decode(payload));
      var restaurant = data.restaurants[index];
      Navigation.intentWithData(routeName: route, arguments: restaurant);
    });
  }
}
