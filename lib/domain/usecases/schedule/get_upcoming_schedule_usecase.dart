import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Get Upcoming Schedule Use Case
/// Business logic for fetching upcoming schedules
class GetUpcomingScheduleUseCase {
  final ScheduleRepository repository;

  GetUpcomingScheduleUseCase({required this.repository});

  Future<Either<Failure, UpcomingRecurringBody>> call() async {
    return await repository.getUpcomingSchedule();
  }
}
