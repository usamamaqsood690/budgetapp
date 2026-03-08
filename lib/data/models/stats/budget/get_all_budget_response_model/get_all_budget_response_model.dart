class BudgetResponse {
  final bool status;
  final String message;
  final BudgetBody body;

  BudgetResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory BudgetResponse.fromJson(Map<String, dynamic> json) {
    return BudgetResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: BudgetBody.fromJson(json['body'] ?? {}),
    );
  }
}

class BudgetBody {
  final double totalBudget;
  final double totalSpend;
  final double totalRemaining;
  final double percentageRemaining;
  final List<Category> category;
  final List<BudgetItem> budgets;
  BudgetBody({
    required this.category,
    required this.budgets,
    required this.totalBudget,
    required this.totalSpend,
    required this.totalRemaining,
    required this.percentageRemaining,
  });

  factory BudgetBody.fromJson(Map<String, dynamic> json) {
    return BudgetBody(
      category: (json['category'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      budgets: (json['budgets'] as List? ?? [])
          .map((e) => BudgetItem.fromJson(e))
          .toList(),
      totalBudget: (json['totalBudget'] ?? 0).toDouble(),
      totalSpend: (json['totalSpend'] ?? 0).toDouble(),
      totalRemaining: (json['totalRemaining'] ?? 0).toDouble(),
      percentageRemaining: (json['percentageRemaining'] ?? 0).toDouble(),
    );
  }
}

class Category {
  final String id;
  final String categoryName;
  final double budgetAmount;
  final double budgetSpend;
  final double budgetRemaining;
  final String iconUrl;

  Category({
    required this.id,
    required this.categoryName,
    required this.budgetAmount,
    required this.budgetSpend,
    required this.budgetRemaining,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      budgetAmount: (json['budgetAmount'] ?? 0).toDouble(),
      budgetSpend: (json['budgetSpend'] ?? 0).toDouble(),
      budgetRemaining: (json['budgetRemaining'] ?? 0).toDouble(),
      iconUrl: json['icon_url'] ?? '',
    );
  }
}

class BudgetItem {
  final String name;
  final String logoUrl;
  final bool isRecurring;
  final String recurrenceInterval;
  final String id;
  final String category;
  final double amount;
  final String description;
  final String date;
  final String personalFinanceCategoryIconUrl;

  BudgetItem({
    required this.name,
    required this.logoUrl,
    required this.isRecurring,
    required this.recurrenceInterval,
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.personalFinanceCategoryIconUrl,
  });

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      name: json['name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      isRecurring: json['isRecurring'] ?? false,
      recurrenceInterval: json['recurrenceInterval'] ?? '',
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      personalFinanceCategoryIconUrl:
      json['personal_finance_category_icon_url'] ?? '',
    );
  }
}