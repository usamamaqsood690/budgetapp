import 'package:flutter/material.dart';
import 'package:wealthnxai/data/models/stats/stats_chart_graph_model/graph_data_model/graph_data_model.dart';
import 'package:wealthnxai/presentation/widgets/graph_chart/app_graph_chart.dart';

/// Empty graph chart widget that displays a horizontal line at zero
class EmptyAppGraphChart extends StatelessWidget {

  const EmptyAppGraphChart({
    super.key,
  });
  /// Creates dummy data with 5 points, all with value 0
  List<GraphData> _createDummyData() {
    return List.generate(
      5,
          (index) => GraphData(
        label: '',
        volume: 0.0,
            total: 0.0
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AppGraphChart(data: _createDummyData());
  }
}
