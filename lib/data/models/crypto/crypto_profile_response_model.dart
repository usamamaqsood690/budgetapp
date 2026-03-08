// lib/data/models/crypto/crypto_profile_response_model.dart

import 'package:wealthnxai/data/models/crypto/crypto_coin_model.dart';

/// Response shape:
/// {
///   "status": true,
///   "message": "Crypto profile fetched successfully",
///   "body": { ...CryptoCoinModel }
/// }
class CryptoProfileResponseModel {
  final bool status;
  final String message;
  final CryptoCoinModel body;

  CryptoProfileResponseModel({
    required this.status,
    required this.message,
    required this.body,
  });

  factory CryptoProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return CryptoProfileResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      body: CryptoCoinModel.fromJson(json['body'] as Map<String, dynamic>),
    );
  }
}