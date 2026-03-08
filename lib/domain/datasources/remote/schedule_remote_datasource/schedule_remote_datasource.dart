import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';

/// Schedule Remote Data Source - contract
/// Responsible only for schedule-related HTTP APIs.
abstract class ScheduleRemoteDataSource {
  /// Get upcoming schedules for the current logged-in user.
  Future<UpcomingRecurringResponse> getUpcomingSchedule();

  /// Get schedules for the current logged-in user.
  Future<GetScheduleResponse> getScheduleByDateTime(String dateTime);

  /// Get monthly calender data .
  Future<MonthlyRecurringExpensesBody> getMonthlyCalenderData(int month , int year);

  /// Delete Schedule
  Future<MessageResponse> deleteSchedule({required String id});

  /// Add a new schedule
  Future<MessageResponse> addSchedule({required Map<String, dynamic> body});

  /// Edit an existing schedule
  Future<MessageResponse> editSchedule({
    required String id,
    required Map<String, dynamic> body,
  });
}
