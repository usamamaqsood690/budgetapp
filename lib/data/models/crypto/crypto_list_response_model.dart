// lib/data/models/crypto/crypto_list_response_model.dart

import 'package:wealthnxai/data/models/crypto/crypto_coin_model.dart';

/// Response shape:
/// {
///   "status": true,
///   "message": "Crypto list fetched successfully",
///   "body": [ ...CryptoCoinModel ]
/// }
class CryptoListResponseModel {
  final bool status;
  final String message;
  final List<CryptoCoinModel> body;

  CryptoListResponseModel({
    required this.status,
    required this.message,
    required this.body,
  });

  factory CryptoListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['body'] as List<dynamic>? ?? [];
    return CryptoListResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      body: rawList
          .map((e) => CryptoCoinModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}