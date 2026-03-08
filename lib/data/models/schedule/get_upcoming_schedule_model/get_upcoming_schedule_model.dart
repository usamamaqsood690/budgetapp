import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';

class UpcomingRecurringResponse {
  final bool status;
  final String message;
  final UpcomingRecurringBody body;

  UpcomingRecurringResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory UpcomingRecurringResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingRecurringResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      body:  UpcomingRecurringBody.fromJson(json['body']),
    );
  }
}

class UpcomingRecurringBody {
  final List<RecurringItem> scheduleList;
  final List<CurrentMonthWeek> currentMonth;
  final double currentMonthTotal;

  UpcomingRecurringBody({
    required this.scheduleList,
    required this.currentMonth,
    required this.currentMonthTotal,
  });

  factory UpcomingRecurringBody.fromJson(Map<String, dynamic> json) {
    return UpcomingRecurringBody(
      scheduleList: json['schedule_list'] != null
          ? (json['schedule_list'] as List)
          .map((e) => RecurringItem.fromJson(e))
          .toList()
          : <RecurringItem>[],
      currentMonth: json['currentmonth'] != null
          ? (json['currentmonth'] as List)
          .map((e) => CurrentMonthWeek.fromJson(e))
          .toList()
          : <CurrentMonthWeek>[],
      currentMonthTotal: (json['currentmonthtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CurrentMonthWeek {
  final int week;
  final double totalAmount;

  CurrentMonthWeek({
    required this.week,
    required this.totalAmount,
  });

  factory CurrentMonthWeek.fromJson(Map<String, dynamic> json) {
    return CurrentMonthWeek(
      week: json['week'] ?? 0,
      totalAmount: (json['totalamount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
