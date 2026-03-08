import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';

/// Add Schedule Use Case
class AddScheduleUseCase {
  final ScheduleRepository repository;

  AddScheduleUseCase({required this.repository});

  Future<Either<Failure, MessageResponse>> call(AddScheduleParams params) {
    return repository.addSchedule(
      name: params.name,
      category: params.category,
      amount: params.amount,
      date: params.date,
      description: params.description,
      recurrenceInterval: params.recurrenceInterval,
      isRecurring: params.isRecurring

    );
  }
}

class AddScheduleParams extends Equatable {
  final String name;
  final String category;
  final double amount;
  final String date;
  final String? description;
  final String? recurrenceInterval;
  final bool isRecurring;


  const AddScheduleParams({
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.recurrenceInterval,
    required this.isRecurring,
    this.description,
  });

  @override
  List<Object?> get props => [
        name,
        category,
        amount,
        date,
        description,
        recurrenceInterval,
        isRecurring,
      ];
}

