import 'package:get/get.dart';

class ConnectWalletController extends GetxController {
  double? amount;
  String? date;
  String? category;
  String? description;
  @override
  void onInit() {
    super.onInit();
    _loadTransactionData();
  }

  void _loadTransactionData() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // amount can come as double or String – handle both safely
    final dynamic rawAmount = args['amount'];
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else if (rawAmount is String) {
      amount = double.tryParse(rawAmount);
    }

    date = args['date'] as String?;
    category = args['category'] as String?;
    description = args['description'] as String?;
  }

  void onDonePressed() {
    Get.back();
  }
}
