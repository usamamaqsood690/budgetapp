import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/stats/budget/get_all_budget_response_model/get_all_budget_response_model.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/budget_repository/budget_repository.dart';

class GetBudgetUseCase {
  final BudgetRepository repository;

  GetBudgetUseCase({required this.repository});

  Future<Either<Failure, BudgetResponse>> call() async {
    return await repository.getBudgets();
  }
}

