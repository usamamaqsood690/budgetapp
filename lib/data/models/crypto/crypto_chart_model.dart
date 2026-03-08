// lib/data/models/crypto/crypto_chart_model.dart

import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';

class CryptoChartModel extends CryptoChartEntity {
  const CryptoChartModel({
    required super.time,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
  });

  /// CoinGecko OHLC entry format: [timestamp, open, high, low, close]
  factory CryptoChartModel.fromJson(List<dynamic> e) {
    return CryptoChartModel(
      time:  (e[0] as int),
      open:  (e[1] as num).toDouble(),
      high:  (e[2] as num).toDouble(),
      low:   (e[3] as num).toDouble(),
      close: (e[4] as num).toDouble(),
    );
  }
}