import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/datasources/remote/stats_remote_datasource_impl/transaction_remote_datasource_impl/transaction_remote_datasource_impl.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/stats_repository/transaction_repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSourceImpl remoteDataSource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TransactionResponseModel>> getAllTransactions() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final result = await remoteDataSource.getAllTransactions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}

