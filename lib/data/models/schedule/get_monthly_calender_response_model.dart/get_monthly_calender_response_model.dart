import 'package:wealthnxai/core/utils/date_time_helper.dart';

class MonthlyCalenderResponse {
  final bool status;
  final String message;
  final MonthlyRecurringExpensesBody body;

  MonthlyCalenderResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory MonthlyCalenderResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyCalenderResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      body: MonthlyRecurringExpensesBody.fromJson(json['body']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'body': body.toJson()};
  }
}


class MonthlyRecurringExpensesBody {
  final MonthCalendar monthCalendar;

  MonthlyRecurringExpensesBody({
    required this.monthCalendar,
  });

  factory MonthlyRecurringExpensesBody.fromJson(Map<String, dynamic> json) {
    return MonthlyRecurringExpensesBody(
      monthCalendar: MonthCalendar.fromJson(json['month_calendar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month_calendar': MonthCalendarDate,
    };
  }
}

class MonthCalendarDate {
  final String date;
  final List<String> category;

  MonthCalendarDate({required this.date, required this.category});

  factory MonthCalendarDate.fromJson(Map<String, dynamic> json) {
    return MonthCalendarDate(
      // ✅ Or with null safety — use a sentinel, NOT DateTime.now()
      date: json['date'],
      category:
      json['category'] != null
          ? (json['category'] as List).map((e) => e.toString()).toList()
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'category': category};
  }
}

class MonthCalendar {
  final String month;
  final List<MonthCalendarDate> dates;

  MonthCalendar({required this.month, required this.dates});

  factory MonthCalendar.fromJson(Map<String, dynamic> json) {
    return MonthCalendar(
      month: json['month']?.toString() ?? '',
      dates:
      json['dates'] != null
          ? (json['dates'] as List)
          .map((e) => MonthCalendarDate.fromJson(e))
          .toList()
          : <MonthCalendarDate>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'dates': dates.map((e) => e.toJson()).toList()};
  }
}


