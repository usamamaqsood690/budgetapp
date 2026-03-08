// lib/domain/repositories/crypto_repository/crypto_chart_repository.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';

abstract class CryptoChartRepository {
  Future<Either<Failure, List<CryptoChartEntity>>> fetchOhlcChart({
    required String coinId,
    required String days,
  });
}