import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';
import 'package:wealthnxai/presentation/widgets/graph_chart/app_graph_chart.dart';
import 'package:wealthnxai/presentation/widgets/graph_chart/empty_app_graph_chart.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Reusable graph section widget that displays chart data with loading and error states
class ChartGraphSection extends StatelessWidget {
  final RxBool isLoading;
  final RxString error;
  final RxList<GraphData> data;

  const ChartGraphSection({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
  });



  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return SizedBox(
          height: AppSpacing.responTextHeight(200),
          child: const Center(child: AppLoadingWidget()),
        );
      }

      if (error.value.isNotEmpty) {
        return AppText(txt: error.value);
      }

      if (data.isEmpty) {
        return EmptyAppGraphChart();
      }

      return AppGraphChart(data: data.toList());
    });
  }
}
