import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';

/// App Loading Widget
/// A reusable loading spinner widget with theme-aware styling
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
    this.color,
    this.size,
    this.loaderType = AppLoaderType.fadingCube,
  });

  final Color? color;
  final double? size;
  final AppLoaderType loaderType;

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? context.colorScheme.primary;
    final loaderSize = size ?? AppDimensions.iconXL;

    Widget loader;
    switch (loaderType) {
      case AppLoaderType.fadingCube:
        loader = SpinKitFadingCube(color: loaderColor, size: loaderSize);
        break;
      case AppLoaderType.ring:
        loader = SpinKitRing(color: loaderColor, size: loaderSize);
        break;
      case AppLoaderType.doubleBounce:
        loader = SpinKitDoubleBounce(color: loaderColor, size: loaderSize);
        break;
      case AppLoaderType.wave:
        loader = SpinKitWave(color: loaderColor, size: loaderSize);
        break;
      case AppLoaderType.pulse:
        loader = SpinKitPulse(color: loaderColor, size: loaderSize);
        break;
      case AppLoaderType.chasingDots:
        loader = SpinKitChasingDots(color: loaderColor, size: loaderSize);
        break;
    }

    return Center(child: loader);
  }
}

/// Loading widget types
enum AppLoaderType { fadingCube, ring, doubleBounce, wave, pulse, chasingDots }
