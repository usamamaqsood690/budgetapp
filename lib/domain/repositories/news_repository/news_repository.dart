
/// News Repository Interface - Domain Layer
/// Located in: lib/domain/repositories/news_repository.dart

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';

abstract class NewsRepository {
  /// Fetch news by symbol/ticker (e.g., AAPL, BTC)
  Future<Either<Failure, List<NewsEntity>>> fetchNewsBySymbol({
    required String symbol,
    int page = 1,
    int limit = 20,
  });

  /// Fetch latest general news
  Future<Either<Failure, List<NewsEntity>>> fetchGeneralNews({
    int page = 1,
    int limit = 10,
  });

  /// Fetch latest crypto news
  Future<Either<Failure, List<NewsEntity>>> fetchCryptoNews({
    int page = 1,
    int limit = 10,
  });

  /// Fetch latest stock news
  Future<Either<Failure, List<NewsEntity>>> fetchStockNews({
    int page = 1,
    int limit = 10,
  });
}