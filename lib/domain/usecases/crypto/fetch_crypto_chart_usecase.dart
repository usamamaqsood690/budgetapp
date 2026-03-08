// lib/domain/usecases/crypto/fetch_crypto_chart_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_chart_repository.dart';

class FetchCryptoChartUseCase {
  final CryptoChartRepository repository;

  FetchCryptoChartUseCase(this.repository);

  Future<Either<Failure, List<CryptoChartEntity>>> call({
    required String coinId,
    required String days,
  }) =>
      repository.fetchOhlcChart(coinId: coinId, days: days);
}