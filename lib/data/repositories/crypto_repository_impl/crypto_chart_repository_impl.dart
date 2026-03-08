// lib/data/repositories/crypto_repository_impl/crypto_chart_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/datasources/remote/crypto/crypto_chart_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/crypto/crypto_chart_entity.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/crypto_repository/crypto_chart_repository.dart';

class CryptoChartRepositoryImpl implements CryptoChartRepository {
  final CryptoChartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CryptoChartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CryptoChartEntity>>> fetchOhlcChart({
    required String coinId,
    required String days,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await remoteDataSource.fetchOhlcChart(
        coinId: coinId,
        days: days,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}