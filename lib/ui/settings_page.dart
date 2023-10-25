import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/widgets/custom_coming_soon_dialog.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SchedulingProvider(),
        child: PlatformWidget(
            androidBuilder: _buildAndroid, iOSBuilder: _buildIos));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        // TODO: Hapus lagi sebelum submit
        /*floatingActionButton: FloatingActionButton(
          onPressed: () => BackgroundService.callback(),
          child: const Icon(Icons.alarm),
        ),*/
        body: _buildList(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Settings'),
        ),
        child: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) => ListView(
        children: [
          Material(
            color: Colors.white,
            child: ListTile(
                title: const Text('Scheduling Recommendation'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) => Switch.adaptive(
                    value: provider.isDailyRecommendationActive,
                    inactiveTrackColor: Colors.red,
                    activeColor: Colors.green,
                    onChanged: (value) async {
                      if (Platform.isIOS) {
                        customDialog(context);
                      } else {
                        provider.enableDailyRecommendation(value);
                        scheduled.scheduledRecommendation(value);
                      }
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
