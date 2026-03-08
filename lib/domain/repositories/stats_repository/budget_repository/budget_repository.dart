import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/budget/get_all_budget_response_model/get_all_budget_response_model.dart';

abstract class BudgetRepository {
  Future<Either<Failure, BudgetResponse>> getBudgets();
}

