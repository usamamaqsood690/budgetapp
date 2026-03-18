import 'package:get/get.dart';

class CategoryBudgetController extends GetxController {
  final categories = <String>[].obs;
  final selectedCategory = ''.obs;
  final budgetAmount = 0.0.obs;
  final spentAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  void _loadCategories() {
    categories.value = [
      'Food',
      'Transport',
      'Entertainment',
      'Health',
      'Shopping',
    ];
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setBudgetAmount(double amount) {
    budgetAmount.value = amount;
  }

  void setSpentAmount(double amount) {
    spentAmount.value = amount;
  }

  double getRemainingBudget() {
    return budgetAmount.value - spentAmount.value;
  }

  double getBudgetPercentage() {
    if (budgetAmount.value == 0) return 0;
    return (spentAmount.value / budgetAmount.value) * 100;
  }
}
