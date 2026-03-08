// lib/domain/usecases/crypto/fetch_crypto_profile_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_repository.dart';

class FetchCryptoProfileUseCase {
  final CryptoRepository repository;

  FetchCryptoProfileUseCase(this.repository);

  Future<Either<Failure, CryptoCoinEntity>> call({
    required String coinId,
  }) {
    return repository.fetchCryptoProfile(coinId: coinId);
  }
}