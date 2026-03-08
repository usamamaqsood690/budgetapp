// lib/data/repositories/crypto_repository_impl/crypto_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // ─── Fetch List ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CryptoCoinEntity>>> fetchCryptoList({
    CryptoListType listType = CryptoListType.all,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await remoteDataSource.fetchCryptoList(
        listType: listType,
        page: page,
        limit: limit,
      );
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  // ─── Search ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CryptoCoinEntity>>> searchCrypto({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await remoteDataSource.searchCryptoList(
        search: query,
        page: page,
        limit: limit,
      );
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  // ─── Fetch Profile ───────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, CryptoCoinEntity>> fetchCryptoProfile({
    required String coinId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final response = await remoteDataSource.fetchCryptoProfile(sym: coinId);
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}