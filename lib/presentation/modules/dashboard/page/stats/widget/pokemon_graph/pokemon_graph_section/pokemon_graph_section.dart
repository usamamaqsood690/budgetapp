
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/empty_pokemon_graph/empty_pokemon_graph.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/monthly_summary/monthly_summary_widget.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/monthly_summary/monthly_summery_shimmer.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/pokemon_graph/pokemon_graph.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class PokemonGraphSection extends StatelessWidget {
  final dynamic controller;
  final String title1;
  final String title2;
  final String title3;
  const PokemonGraphSection({super.key, required this.controller,required this.title1,required this.title2,required this.title3});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.isPokemonChartLoading.value) {
        return Column(
          children: [
            AppSpacing.addHeight(AppSpacing.md),
            PokemonGraphChart(
              isLoading: true,
              height: AppSpacing.responTextHeight(200),
              data: const [],
              selectedMonth: null,
              onMonthSelected: controller.selectPokemonMonth,
            ),
            AppSpacing.addHeight(AppSpacing.md),
            const MonthlySummaryShimmer(),
          ],
        );
      }

      // Error state
      if (controller.pokemonChartError.value.isNotEmpty) {
        return AppText(txt: controller.pokemonChartError.value);
      }

      // Empty state
      if (controller.pokemonChartData.isEmpty) {
        return Column(
          children: [
            AppSpacing.addHeight(AppSpacing.lg),
            EmptyPokemonGraph(
              height: AppSpacing.responTextHeight(150),
              onMonthSelected: controller.selectPokemonMonth,
            ),
            AppSpacing.addHeight(AppSpacing.md),
            MonthlySummaryWidget(
              title1: "Income",
              title2: "Expense",
              title3: "Cash Flow",
            ),
          ],
        );
      }

      // Data loaded
      final selected = controller.selectedPokemonMonth.value ??
          controller.pokemonChartData.last;
      final parts = selected.monthName.split(' ');
      final String monthTitle =
      parts.isNotEmpty ? parts.first : selected.monthName;
      final String? yearTitle = parts.length > 1 ? parts.last : null;

      return Column(
        children: [
          PokemonGraphChart(
            isLoading: false,
            height: AppSpacing.responTextHeight(200),
            data: controller.pokemonChartData.toList(),
            selectedMonth: selected,
            onMonthSelected: controller.selectPokemonMonth,
          ),
          AppSpacing.addHeight(AppSpacing.md),
          MonthlySummaryWidget(
            monthTitle: monthTitle,
            yearTitle: yearTitle,
            title1: title1,
            value1: selected.value1,
            valuePercent1: selected.percentValue1,
            title2: title2,
            value2: selected.value2,
            valuePercent2: selected.percentValue2,
            title3: title3,
            value3: selected.value3,
            valuePercent3: selected.percentValue3,
          ),
        ],
      );
    });
  }
}