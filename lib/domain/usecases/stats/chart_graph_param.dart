import 'package:equatable/equatable.dart';

/// Time Range for Chart Graph Summary Parameters
class TimeRangeParams extends Equatable {
  final String timeRange;

  const TimeRangeParams({required this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}
