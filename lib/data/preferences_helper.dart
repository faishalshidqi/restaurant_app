import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const dailyRecommendation = 'DAILY_RECOMMENDATION';
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isScheduledRecommendationActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyRecommendation) ?? false;
  }

  void setScheduledRecommendation(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyRecommendation, value);
  }
}
