import 'package:flutter/material.dart';
import 'package:wealthnxai/data/models/stats/pokemon_chart_graph_model/pokimon_chart_graph_model.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/pokemon_graph.dart';

class EmptyPokemonGraph extends StatelessWidget {
  final double height;
  final Function(PokemonChartGraphModel)? onMonthSelected;

  const EmptyPokemonGraph({super.key, this.height = 120, this.onMonthSelected});

  @override
  Widget build(BuildContext context) {
    return PokemonGraphChart(
      isLoading: false,
      height: height,
      data: <PokemonChartGraphModel>[
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Jan',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Feb',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Mar',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Apr',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'May',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Jun',
        ),
        PokemonChartGraphModel(
          value1: 0.0,
          value2: 0.0,
          value3: 0.0,
          monthName: 'Jul',
        ),
      ],
      selectedMonth: null,
      onMonthSelected: onMonthSelected ?? (monthData) {},
    );
  }
}
