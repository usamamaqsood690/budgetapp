class CashFlowDetailResponse {
  final bool status;
  final String message;
  final CashFlowDetailBody body;

  CashFlowDetailResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory CashFlowDetailResponse.fromJson(Map<String, dynamic> json) {
    return CashFlowDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: CashFlowDetailBody.fromJson(json['body'] ?? {}),
    );
  }
}

class CashFlowDetailBody {
  final double income;
  final double expenses;
  final double cashFlow;
  final double incomePercentChange;
  final double expensePercentChange;
  final double cashFlowPercentChange;
  final List<CashFlowTransaction> incomeBreakdown;
  final List<CashFlowTransaction> expenseBreakdown;
  final List<CashFlowTransaction> recurringExpenses;

  CashFlowDetailBody({
    required this.income,
    required this.expenses,
    required this.cashFlow,
    required this.incomePercentChange,
    required this.expensePercentChange,
    required this.cashFlowPercentChange,
    required this.incomeBreakdown,
    required this.expenseBreakdown,
    required this.recurringExpenses,
  });

  factory CashFlowDetailBody.fromJson(Map<String, dynamic> json) {
    return CashFlowDetailBody(
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0.0,
      cashFlow: (json['cashflow'] as num?)?.toDouble() ?? 0.0,
      incomeBreakdown:
          (json['incomeBreakdown'] as List<dynamic>?)
              ?.map((e) => CashFlowTransaction.fromJson(e))
              .toList() ??
          [],
      expenseBreakdown:
          (json['expenseBreakdown'] as List<dynamic>?)
              ?.map((e) => CashFlowTransaction.fromJson(e))
              .toList() ??
          [],
      recurringExpenses:
          (json['recurringExpenses'] as List<dynamic>?)
              ?.map((e) => CashFlowTransaction.fromJson(e))
              .toList() ??
          [],cashFlowPercentChange: (json['cashflowPercentChange'] as num?)?.toDouble() ?? 0.0,
      expensePercentChange: (json['expensePercentChange'] as num?)?.toDouble() ?? 0.0,
      incomePercentChange: (json['incomePercentChange'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CashFlowTransaction {
  final String category;
  final String title;
  final String logoUrl;
  final double amount;
  final String description;
  final String date;
  final String personalFinanceCategoryIconUrl;

  CashFlowTransaction({
    required this.category,
    required this.title,
    required this.logoUrl,
    required this.amount,
    required this.description,
    required this.date,
    required this.personalFinanceCategoryIconUrl,
  });

  factory CashFlowTransaction.fromJson(Map<String, dynamic> json) {
    return CashFlowTransaction(
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      personalFinanceCategoryIconUrl:
          json['personal_finance_category_icon_url'] ?? '',
    );
  }
}

class TransactionCategory {
  final String name;
  final double totalAmount;
  final String categoryIcon;
  final List<CashFlowTransaction> categoryTransactions;

  TransactionCategory({
    required this.name,
    required this.totalAmount,
    required this.categoryIcon,
    required this.categoryTransactions,
  });

  /// Groups transactions by category and returns sorted list (descending by totalAmount)
  static List<TransactionCategory> groupByCategory(
    List<CashFlowTransaction> transactions,
  ) {
    final Map<String, List<CashFlowTransaction>> categoryMap = {};

    // Group transactions by category
    for (final transaction in transactions) {
      final categoryName =
          transaction.category.isEmpty ? 'Uncategorized' : transaction.category;

      if (!categoryMap.containsKey(categoryName)) {
        categoryMap[categoryName] = [];
      }
      categoryMap[categoryName]!.add(transaction);
    }

    // Convert map to list of TransactionCategory
    final categories =
        categoryMap.entries.map((entry) {
          final txns = entry.value;
          final totalAmount = txns.fold<double>(
            0.0,
            (sum, t) => sum + t.amount,
          );
          final categoryIcon = txns.first.personalFinanceCategoryIconUrl;

          return TransactionCategory(
            name: entry.key,
            totalAmount: totalAmount,
            categoryIcon: categoryIcon,
            categoryTransactions: txns,
          );
        }).toList();

    // Sort by totalAmount in descending order
    categories.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return categories;
  }
}
