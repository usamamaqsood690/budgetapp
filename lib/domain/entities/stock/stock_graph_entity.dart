class StockGraphEntity {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final DateTime date;

  const StockGraphEntity({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.date,
  });
}