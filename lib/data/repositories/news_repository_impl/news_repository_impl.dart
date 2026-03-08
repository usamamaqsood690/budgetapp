
/// News Repository Implementation - Data Layer
/// Located in: lib/data/repositories/news_repository_impl/news_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/datasources/remote/news_remote_data_source.dart';
import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/news_repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> fetchNewsBySymbol({
    required String symbol,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await remoteDataSource.fetchNewsBySymbol(
        symbol: symbol,
        page: page,
        limit: limit,
      );
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> fetchGeneralNews({
    int page = 1,
    int limit = 10,
  }) async {
    return _fetchLatestNews(type: 'general', page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> fetchCryptoNews({
    int page = 1,
    int limit = 10,
  }) async {
    return _fetchLatestNews(type: 'crypto', page: page, limit: limit);
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> fetchStockNews({
    int page = 1,
    int limit = 10,
  }) async {
    return _fetchLatestNews(type: 'stock', page: page, limit: limit);
  }

  /// Private helper method to fetch latest news by type
  Future<Either<Failure, List<NewsEntity>>> _fetchLatestNews({
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await remoteDataSource.fetchLatestNews(
        type: type,
        page: page,
        limit: limit,
      );
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}