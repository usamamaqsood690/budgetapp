// lib/domain/datasources/remote/crypto/crypto_chart_remote_datasource.dart

import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';

abstract class CryptoChartRemoteDataSource {
  Future<List<CryptoChartEntity>> fetchOhlcChart({
    required String coinId,
    required String days,
  });
}