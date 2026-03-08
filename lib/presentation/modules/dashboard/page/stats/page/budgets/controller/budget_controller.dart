import 'package:get/get.dart';
import 'package:wealthnxai/data/models/stats/budget/get_all_budget_response_model/get_all_budget_response_model.dart';
import 'package:wealthnxai/domain/usecases/stats/budget/get_budget_usecase.dart';

class BudgetController extends GetxController {
  BudgetController({required this.getBudgetUseCase});

  final GetBudgetUseCase getBudgetUseCase;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final budgetResponse = Rxn<BudgetResponse>();

  BudgetBody? get budgetBody => budgetResponse.value?.body;

  @override
  void onInit() {
    super.onInit();
    fetchBudgets();
  }

  Future<void> fetchBudgets() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await getBudgetUseCase();
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          budgetResponse.value = null;
        },
        (response) {
          budgetResponse.value = response;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      budgetResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}