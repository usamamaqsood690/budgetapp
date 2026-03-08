import 'package:wealthnxai/data/models/stats/budget/get_all_budget_response_model/get_all_budget_response_model.dart';

/// Contract for budget-related remote operations
abstract class BudgetRemoteDataSource {
  Future<BudgetResponse> getBudgets();
}

