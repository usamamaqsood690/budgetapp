import 'package:flutter/foundation.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';

class GetScheduleResponse {
  final bool status;
  final String message;
  final RecurringExpensesBody body;

  GetScheduleResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory GetScheduleResponse.fromJson(Map<String, dynamic> json) {
    return GetScheduleResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      body: RecurringExpensesBody.fromJson(json['body']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'body': body.toJson()};
  }
}

class RecurringExpensesBody {
  final DateTime date;
  final double monthlyAmount;
  final double dailyAmount;
  final int totalSubscription;
  final List<RecurringItem> recurringList;

  RecurringExpensesBody({
    required this.date,
    required this.monthlyAmount,
    required this.dailyAmount,
    required this.totalSubscription,
    required this.recurringList,
  });

  factory RecurringExpensesBody.fromJson(Map<String, dynamic> json) {
    // Debug: Print what we're parsing
    final monthlyAmount = (json['monthly_amount'] as num?)?.toDouble() ?? 0.0;
    final dailyAmount = (json['daily_amount'] as num?)?.toDouble() ?? 0.0;
    final totalSubs = json['total_subscription'] ?? 0;

    return RecurringExpensesBody(
      date: DateTimeConverter.toShortDateUS(json['date'] as String),
      monthlyAmount: monthlyAmount,
      dailyAmount: dailyAmount,
      totalSubscription:
          totalSubs is int ? totalSubs : (totalSubs as num?)?.toInt() ?? 0,
      recurringList:
          json['schedule_list'] != null
              ? (json['schedule_list'] as List)
                  .map((e) => RecurringItem.fromJson(e))
                  .toList()
              : <RecurringItem>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'monthly_amount': monthlyAmount,
      'daily_amount': dailyAmount,
      'total_subscription': totalSubscription,
      'schedule_list': recurringList.map((e) => e.toJson()).toList(),
    };
  }
}

class RecurringItem {
  final String name;
  final String logoUrl;
  final bool isRecurring;
  final String recurrenceInterval;
  final String id;
  final String category;
  final String tagType;
  final double amount;
  final String description;
  final DateTime date;
  final DateTime lastDate;
  final String source;

  RecurringItem({
    required this.name,
    required this.logoUrl,
    required this.isRecurring,
    required this.recurrenceInterval,
    required this.id,
    required this.category,
    required this.tagType,
    required this.amount,
    required this.description,
    required this.date,
    required this.lastDate,
    required this.source,
  });

  factory RecurringItem.fromJson(Map<String, dynamic> json) {
    return RecurringItem(
      name: json['name']?.toString() ?? '',
      logoUrl: json['logo_url']?.toString() ?? '',
      isRecurring: json['isRecurring'] ?? false,
      recurrenceInterval: json['recurrence_interval']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tagType: json['tag_type']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      date: DateTimeConverter.toShortDateUS(json['date'] as String),
      lastDate: DateTimeConverter.toShortDateUS(json['last_date'] as String),
      source: json['source']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo_url': logoUrl,
      'isRecurring': isRecurring,
      'recurrence_interval': recurrenceInterval,
      'id': id,
      'category': category,
      'tag_type': tagType,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'last_date': lastDate.toIso8601String(),
      'source': source,
    };
  }
}
