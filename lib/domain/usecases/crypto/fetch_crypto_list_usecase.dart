// lib/domain/usecases/crypto/fetch_crypto_list_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_repository.dart';

class FetchCryptoListUseCase {
  final CryptoRepository repository;

  FetchCryptoListUseCase(this.repository);

  Future<Either<Failure, List<CryptoCoinEntity>>> call({
    CryptoListType listType = CryptoListType.all,
    int page = 1,
    int limit = 20,
  }) {
    return repository.fetchCryptoList(
      listType: listType,
      page: page,
      limit: limit,
    );
  }
}