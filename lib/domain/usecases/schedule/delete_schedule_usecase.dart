import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Delete Schedule UseCase - domain layer
class DeleteScheduleUseCase {
  final ScheduleRepository repository;

  DeleteScheduleUseCase({required this.repository});

  Future<Either<Failure, MessageResponse>> call(DeleteScheduleParams params) {
    return repository.deleteSchedule(params.id);
  }
}

class DeleteScheduleParams extends Equatable {
  final String id;

  const DeleteScheduleParams({
    required this.id,
  });

  @override
  List<Object?> get props => [
    id,
  ];
}

