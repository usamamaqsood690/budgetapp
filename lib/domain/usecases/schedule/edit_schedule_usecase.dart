import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Edit Schedule Use Case
class EditScheduleUseCase {
  final ScheduleRepository repository;

  EditScheduleUseCase({required this.repository});

  Future<Either<Failure, MessageResponse>> call(EditScheduleParams params) {
    return repository.editSchedule(
      id: params.id,
      name: params.name,
      category: params.category,
      amount: params.amount,
      date: params.date,
      description: params.description,
      recurrenceInterval: params.recurrenceInterval,
    );
  }
}

class EditScheduleParams extends Equatable {
  final String id;
  final String name;
  final String category;
  final double amount;
  final String date;
  final String? description;
  final String? recurrenceInterval;

  const EditScheduleParams({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.recurrenceInterval,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        amount,
        date,
        description,
        recurrenceInterval,
      ];
}

