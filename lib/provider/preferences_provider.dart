import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRecommendationPreferences();
  }

  bool _isDailyRecommendationActive = false;

  bool get isDailyRecommendationActive => _isDailyRecommendationActive;

  void _getDailyRecommendationPreferences() async {
    _isDailyRecommendationActive =
        await preferencesHelper.isScheduledRecommendationActive;
    notifyListeners();
  }

  void enableDailyRecommendation(bool value) {
    preferencesHelper.setScheduledRecommendation(value);
    _getDailyRecommendationPreferences();
  }
}
