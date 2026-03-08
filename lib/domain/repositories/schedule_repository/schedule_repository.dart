import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';

/// Schedule Repository - domain contract
abstract class ScheduleRepository {
  /// Get upcoming schedules for the current logged-in user.
  Future<Either<Failure, UpcomingRecurringBody>> getUpcomingSchedule();

  /// Get schedules for the current logged-in user.
  Future<Either<Failure, RecurringExpensesBody>> getScheduleByDateTime(String dateTime);

  /// Delete a schedule by its ID.
  Future<Either<Failure, MessageResponse>> deleteSchedule(String id);

  ///Get monthly schedule of user.
  Future<Either<Failure, MonthlyRecurringExpensesBody>> getMonthlySchedule(int month, int year);

  /// Add a new schedule
  Future<Either<Failure, MessageResponse>> addSchedule({
    required String name,
    required String category,
    required double amount,
    required String date,
    String? description,
    required String? recurrenceInterval,
    required bool isRecurring
  });

  /// Edit an existing schedule
  Future<Either<Failure, MessageResponse>> editSchedule({
    required String id,
    required String name,
    required String category,
    required double amount,
    required String date,
    String? description,
    required String?  recurrenceInterval,
  });
}
