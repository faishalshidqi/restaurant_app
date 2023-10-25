import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/favorite_list_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/restaurant_list_page.dart';
import 'package:restaurant_app/ui/settings_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;
  final List<BottomNavigationBarItem> _bottomNavigationBarItem = [
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home_filled),
        label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.star : Icons.star_border),
        label: 'Favorites'),
    BottomNavigationBarItem(
        icon: Icon(
            Platform.isIOS ? CupertinoIcons.settings_solid : Icons.settings),
        label: 'Settings'),
  ];
  final List<Widget> _listWidget = [
    const RestaurantListPage(),
    const FavoriteListPage(),
    const SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.green,
        items: _bottomNavigationBarItem,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            activeColor: Colors.green, items: _bottomNavigationBarItem),
        tabBuilder: (context, index) {
          return _listWidget[index];
        });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iOSBuilder: _buildIos);
  }
}
