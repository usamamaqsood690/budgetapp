import 'package:wealthnxai/domain/entities/stock/stock_graph_entity.dart';

class StockGraphModel extends StockGraphEntity {
  const StockGraphModel({
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
    required super.date,
  });

  /// Used for intraday (1min) chart response: List of flat objects
  factory StockGraphModel.fromIntradayJson(Map<String, dynamic> json) {
    return StockGraphModel(
      open: _parseDouble(json['open']),
      high: _parseDouble(json['high']),
      low: _parseDouble(json['low']),
      close: _parseDouble(json['close']),
      volume: _parseDouble(json['volume']),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Used for historical-price-full response: { historical: [...] }
  factory StockGraphModel.fromHistoricalJson(Map<String, dynamic> json) {
    return StockGraphModel(
      open: _parseDouble(json['open']),
      high: _parseDouble(json['high']),
      low: _parseDouble(json['low']),
      close: _parseDouble(json['close']),
      volume: _parseDouble(json['volume']),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}