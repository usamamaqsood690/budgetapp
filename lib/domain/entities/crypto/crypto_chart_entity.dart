// lib/domain/entities/crypto/crypto_chart_entity.dart

class CryptoChartEntity {
  final int time;
  final double open;
  final double high;
  final double low;
  final double close;

  const CryptoChartEntity({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}