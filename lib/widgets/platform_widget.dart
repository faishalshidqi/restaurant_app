import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder androidBuilder;
  final WidgetBuilder iOSBuilder;
  const PlatformWidget(
      {super.key, required this.androidBuilder, required this.iOSBuilder});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iOSBuilder(context);
      default:
        return androidBuilder(context);
    }
  }
}
