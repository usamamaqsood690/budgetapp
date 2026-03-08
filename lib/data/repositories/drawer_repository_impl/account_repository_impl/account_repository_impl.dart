import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/plaid_connection_plaid_response_model/plaid_connection_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/account_remote_datasource/account_remote_datasource.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/account_repository/account_repository.dart';

class PlaidAccountRepositoryImpl implements PlaidAccountRepository{
  final PlaidAccountRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlaidAccountRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PlaidConnectionResponse>> plaidConnectionCheck() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final res = await remoteDataSource.plaidConnectionCheck(
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}
