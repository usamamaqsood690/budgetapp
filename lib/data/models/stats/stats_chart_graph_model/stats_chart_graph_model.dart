class ChartGraphResponse {
  final bool status;
  final String message;
  final List<ChartSummary> body;

  ChartGraphResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory ChartGraphResponse.fromJson(Map<String, dynamic> json) => ChartGraphResponse(
    status: json['status'] ?? false,
    message: json['message'] ?? '',
    body: (json['body'] as List<dynamic>?)
        ?.map((e) => ChartSummary.fromJson(e))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'body': body.map((e) => e.toJson()).toList(),
  };
}

class ChartSummary {
  final String monthName;
  final double total;
  final double volume;

  ChartSummary({
    required this.monthName,
    required this.total,
    required this.volume,
  });

  factory ChartSummary.fromJson(Map<String, dynamic> json) => ChartSummary(
    monthName: json['monthName'] ?? '',
    total: (json['total'] ?? 0).toDouble(),
    volume: (json['volume'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'monthName': monthName,
    'total': total,
    'volume': volume,
  };
}