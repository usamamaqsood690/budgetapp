
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

class GetMonthlyCalenderUseCase {
  final ScheduleRepository repository;

  GetMonthlyCalenderUseCase({required this.repository});

  Future<Either<Failure, MonthlyRecurringExpensesBody>> call(GetMonthlyCalenderDataParams param) async {
    return await repository.getMonthlySchedule( param.month, param.year);
  }
}
/// fetching schedules Parameters
class GetMonthlyCalenderDataParams extends Equatable {
  final int month;
  final int year;

  const GetMonthlyCalenderDataParams({required this.month,required this.year});

  @override
  List<Object?> get props => [month,year];
}