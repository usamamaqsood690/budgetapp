// lib/domain/usecases/crypto/search_crypto_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_repository.dart';

class SearchCryptoUseCase {
  final CryptoRepository repository;

  SearchCryptoUseCase(this.repository);

  Future<Either<Failure, List<CryptoCoinEntity>>> call({
    required String query,
    int page = 1,
    int limit = 20,
  }) {
    return repository.searchCrypto(
      query: query,
      page: page,
      limit: limit,
    );
  }
}