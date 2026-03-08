// lib/presentation/modules/topMover/widget/topmover_chart_interface.dart

import 'package:get/get.dart';
import 'package:k_chart_plus_deeping/entity/k_line_entity.dart';

import '../../../../core/constants/app_enums.dart';

abstract class TopMoverChartInterface {
  List<KLineEntity> get chartData;
  RxBool get isChartLoading;
  RxBool get isChartFit;
  RxString get selectedRange;
  Rx<ChartMode> get chartMode;
  RxString get errorMessage;
  List<String> get chartDateFormat;

  void setRange(String range);
  void setMode(ChartMode mode);
}

