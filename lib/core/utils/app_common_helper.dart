import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';

class CommonAppHelper {
  /// Category color mapping
  static Color getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FOOD_AND_DRINK':
        return AppColorScheme.error;
      case 'TRANSPORTATION':
        return AppColorScheme.success;
      case 'SHOPPING':
        return Colors.purple;
      case 'ENTERTAINMENT':
        return Colors.orange;
      case 'BILLS_AND_UTILITIES':
        return Colors.red;
      case 'GENERAL_MERCHANDISE':
        return Colors.blue;
      case 'GENERAL_SERVICES':
        return Colors.teal;
      case 'GOVERNMENT_AND_NON_PROFIT':
        return Colors.grey;
      case 'HOME_IMPROVEMENT':
        return Colors.brown;
      case 'MEDICAL':
        return Colors.pink;
      case 'PERSONAL_CARE':
        return Colors.cyan;
      case 'TRAVEL':
        return Colors.amber;
      case 'OTHER':
        return Colors.transparent;
      default:
        return Colors.indigo;
    }
  }

  /// Category icon mapping
  static IconData getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'FOOD_AND_DRINK':
        return Icons.restaurant;
      case 'TRANSPORTATION':
        return Icons.directions_car;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'ENTERTAINMENT':
        return Icons.movie;
      case 'BILLS_AND_UTILITIES':
        return Icons.receipt;
      case 'GENERAL_MERCHANDISE':
        return Icons.store;
      case 'GENERAL_SERVICES':
        return Icons.build;
      case 'GOVERNMENT_AND_NON_PROFIT':
        return Icons.account_balance;
      case 'HOME_IMPROVEMENT':
        return Icons.home;
      case 'MEDICAL':
        return Icons.local_hospital;
      case 'PERSONAL_CARE':
        return Icons.spa;
      case 'TRAVEL':
        return Icons.flight;
      case 'OTHER':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  /// Category label mapping
  static String getCategoryLabel(String category) {
    switch (category.toUpperCase()) {
      case 'FOOD_AND_DRINK':
        return 'Food & Drink';
      case 'TRANSPORTATION':
        return 'Transportation';
      case 'SHOPPING':
        return 'Shopping';
      case 'ENTERTAINMENT':
        return 'Entertainment';
      case 'BILLS_AND_UTILITIES':
        return 'Bills & Utilities';
      case 'GENERAL_MERCHANDISE':
        return 'General Merchandise';
      case 'GENERAL_SERVICES':
        return 'General Services';
      case 'GOVERNMENT_AND_NON_PROFIT':
        return 'Government & Non-Profit';
      case 'HOME_IMPROVEMENT':
        return 'Home Improvement';
      case 'MEDICAL':
        return 'Medical';
      case 'PERSONAL_CARE':
        return 'Personal Care';
      case 'TRAVEL':
        return 'Travel';
      case 'OTHER':
        return 'Other';
      default:
        return category;
    }
  }

  static List<Color> fixedColors = [
    Color(0xFF1A93D9),
    Color(0xFF57ED6D),
    Color(0xFFEFCA39),
    Color(0xFFE37F51),
    Color(0xFFD93977),
  ];

  /// Builds pie chart sections from categories
  static List<PieChartSectionData> buildPieChartSections(
      List<TransactionCategory> categories,
      double total,
      ) {
    if (total == 0 || categories.isEmpty) {
      return [];
    }
    final topCategories = categories.take(5).toList();

    return List.generate(topCategories.length, (index) {
      final category = topCategories[index];
      final percentage = (category.totalAmount / total) * 100;

      return PieChartSectionData(
        color: fixedColors[index % fixedColors.length],
        showTitle: false,
        value: category.totalAmount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 10,
        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      );
    });
  }

  /// Formats category name from snake_case to Title Case
  static String formatCategoryName(String name) {
    return name
        .toLowerCase()
        .split('_')
        .map(
          (w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '',
    )
        .join(' ');
  }

}
