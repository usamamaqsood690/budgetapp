import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Get Schedule Use Case
/// Business logic for fetching schedules based on a specific DateTime.
class GetScheduleUseCase {
  final ScheduleRepository repository;

  GetScheduleUseCase({required this.repository});

  Future<Either<Failure, RecurringExpensesBody>> call(GetScheduleParams param) async {
    final formattedDate = DateTimeConverter.toISODate(param.dateTime);
    return await repository.getScheduleByDateTime(formattedDate);
  }
}
/// fetching schedules Parameters
class GetScheduleParams extends Equatable {
  final DateTime dateTime;

  const GetScheduleParams({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}
