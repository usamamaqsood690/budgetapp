// lib/domain/repositories/crypto_repository/crypto_repository.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';

abstract class CryptoRepository {
  /// GET /cryptolist?listType=All|Trending|Gainers|Losers|New&page=1&limit=10
  Future<Either<Failure, List<CryptoCoinEntity>>> fetchCryptoList({
    CryptoListType listType,
    int page,
    int limit,
  });

  /// GET /cryptolist?search=eth&page=1&limit=10
  Future<Either<Failure, List<CryptoCoinEntity>>> searchCrypto({
    required String query,
    int page,
    int limit,
  });

  /// GET /cryptoprofile?sym=bitcoin
  Future<Either<Failure, CryptoCoinEntity>> fetchCryptoProfile({
    required String coinId,
  });
}