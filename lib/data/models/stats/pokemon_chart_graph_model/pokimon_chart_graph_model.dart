
import 'package:wealthnxai/core/constants/app_enums.dart';

class PokemonChartGraphModelResponse {
  final bool status;
  final String message;
  final List<PokemonChartGraphModel> body;

  PokemonChartGraphModelResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory PokemonChartGraphModelResponse.fromJson(
      Map<String, dynamic> json,
      PokemonApiSource source,
      ) {
    return PokemonChartGraphModelResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: (json['body'] as List<dynamic>?)
          ?.map((item) => _parseItem(item as Map<String, dynamic>, source))
          .toList() ??
          [],
    );
  }

  static PokemonChartGraphModel _parseItem(
      Map<String, dynamic> json,
      PokemonApiSource source,
      ) {
    switch (source) {
      case PokemonApiSource.cashFlow:
        return PokemonChartGraphModel.fromCashFlowApi(json);
      case PokemonApiSource.netWorth:
        return PokemonChartGraphModel.fromNetWorthApi(json);
      case PokemonApiSource.budget:
        return PokemonChartGraphModel.fromBudgetApi(json);
    }
  }
}

class PokemonChartGraphModel {
  final String monthName;
  final double value1;
  final double value2;
  final double value3;
  final double percentValue1;
  final double percentValue2;
  final double percentValue3;

  PokemonChartGraphModel({
    required this.monthName,
    required this.value1,
    required this.value2,
    required this.value3,
    this.percentValue1 = 0.0,
    this.percentValue2 = 0.0,
    this.percentValue3 = 0.0,
  });

  // API 1: CashFlow API
  factory PokemonChartGraphModel.fromCashFlowApi(Map<String, dynamic> json) {
    return PokemonChartGraphModel(
      monthName: json['monthName'] ?? '',
      value1: (json['income'] as num?)?.toDouble() ?? 0.0,
      value2: (json['expense'] as num?)?.toDouble() ?? 0.0,
      value3: (json['cashflow'] as num?)?.toDouble() ?? 0.0,
      percentValue1: (json['incomepercent'] as num?)?.toDouble() ?? 0.0,
      percentValue2: (json['expensepercent'] as num?)?.toDouble() ?? 0.0,
      percentValue3: (json['cashflowpercent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // API 2: NetWorth API
  factory PokemonChartGraphModel.fromNetWorthApi(Map<String, dynamic> json) {
    return PokemonChartGraphModel(
      monthName: json['monthName'] ?? '',
      value1: (json['asset'] as num?)?.toDouble() ?? 0.0,
      value2: (json['liabilities'] as num?)?.toDouble() ?? 0.0,
      value3: (json['netWorth'] as num?)?.toDouble() ?? 0.0,
      percentValue1: (json['assetpercentage'] as num?)?.toDouble() ?? 0.0,
      percentValue2: (json['liabilitiespercentage'] as num?)?.toDouble() ?? 0.0,
      percentValue3: (json['networthpercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // API 3: Budget API
  factory PokemonChartGraphModel.fromBudgetApi(Map<String, dynamic> json) {
    return PokemonChartGraphModel(
      monthName: json['month'] ?? '',
      value1: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      value2: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      value3: (json['netCashflow'] as num?)?.toDouble() ?? 0.0,
      percentValue1: (json['incomeChange'] as num?)?.toDouble() ?? 0.0,
      percentValue2: (json['expenseChange'] as num?)?.toDouble() ?? 0.0,
      percentValue3: (json['cashflowChange'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Get short label for graph display (e.g., "Mar 2025" -> "Mar")
  String get shortLabel {
    if (monthName.isEmpty) return '';
    return monthName.split(' ').first;
  }
}