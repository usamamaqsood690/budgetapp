import 'package:wealthnxai/core/constants/app_enums.dart';

extension ChartGraphRangeExtension on ChartGraphRange {
  String get value {
    switch (this) {
      case ChartGraphRange.oneMonth:
        return '1M';
      case ChartGraphRange.threeMonths:
        return '3M';
      case ChartGraphRange.sixMonths:
        return '6M';
      case ChartGraphRange.oneYear:
        return '1Y';
      case ChartGraphRange.ytd:
        return 'YTD';
    }
  }
  static ChartGraphRange fromString(String value) {
    switch (value) {
      case '1M':
        return ChartGraphRange.oneMonth;
      case '3M':
        return ChartGraphRange.threeMonths;
      case '6M':
        return ChartGraphRange.sixMonths;
      case '1Y':
        return ChartGraphRange.oneYear;
      case 'YTD':
        return ChartGraphRange.ytd;
      default:
        return ChartGraphRange.oneMonth;
    }
  }
}