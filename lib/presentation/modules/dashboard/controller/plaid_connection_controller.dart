import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/plaid_connection_plaid_response_model/plaid_connection_response_model.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/account_repository/account_repository.dart';
class PlaidConnectionController extends GetxController {
  final PlaidAccountRepository repository;

  PlaidConnectionController({required this.repository});

  final RxBool isLoading = false.obs;
  final Rxn<PlaidConnectionResponse> plaidResponse =
  Rxn<PlaidConnectionResponse>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkPlaidConnection();
  }

  Future<void> checkPlaidConnection() async {
    isLoading.value = true;
    errorMessage.value = '';

    final Either<Failure, PlaidConnectionResponse> result =
    await repository.plaidConnectionCheck();

    result.fold(
          (failure) {
        errorMessage.value = failure.message;
      },
          (response) {
        plaidResponse.value = response;
      },
    );

    isLoading.value = false;
  }
}