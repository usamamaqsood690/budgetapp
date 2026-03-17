import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBudgetController extends GetxController {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final isLoading = false.obs;
  final budgetList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any data
  }

  void addBudget() {
    if (nameController.text.isEmpty || amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      // Add your budget creation logic here
      Get.snackbar('Success', 'Budget added successfully');
      clearFields();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add budget');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    nameController.clear();
    amountController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
