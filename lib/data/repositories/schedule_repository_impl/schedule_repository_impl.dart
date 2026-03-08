import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';
import 'package:wealthnxai/domain/datasources/remote/schedule_remote_datasource/schedule_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Schedule Repository Implementation - data layer
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UpcomingRecurringBody>> getUpcomingSchedule() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.getUpcomingSchedule();
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, RecurringExpensesBody>> getScheduleByDateTime(String dateTime) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.getScheduleByDateTime(dateTime);
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> deleteSchedule(String id) async{
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.deleteSchedule(id: id);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MonthlyRecurringExpensesBody>> getMonthlySchedule(int month, int year) async{
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.getMonthlyCalenderData(month,year);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> addSchedule({
    required String name,
    required String category,
    required double amount,
    required String date,
    String? description,
    String? recurrenceInterval,
    required bool isRecurring
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final body = <String, dynamic>{
        'name': name,
        'category': category,
        'amount': amount,
        'date': date,
        'description': description,
        'recurrenceInterval': recurrenceInterval,
        'isRecurring': isRecurring
      };
      final response = await remoteDataSource.addSchedule(body: body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> editSchedule({
    required String id,
    required String name,
    required String category,
    required double amount,
    required String date,
    String? description,
    required String? recurrenceInterval,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final body = <String, dynamic>{
        'name': name,
        'category': category,
        'amount': amount,
        'date': date,
        'description': description,
        'recurrenceInterval': recurrenceInterval,
      };
      final response = await remoteDataSource.editSchedule(id: id, body: body);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}
