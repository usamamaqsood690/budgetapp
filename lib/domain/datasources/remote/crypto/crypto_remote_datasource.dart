// lib/domain/datasources/remote/crypto/crypto_remote_datasource.dart

import 'package:wealthnxai/data/models/crypto/crypto_list_response_model.dart';
import 'package:wealthnxai/data/models/crypto/crypto_profile_response_model.dart';

/// Supported listType values that map to the API's ?listType= param
enum CryptoListType {
  all('All'),
  trending('Trending'),
  gainers('Gainers'),
  losers('Losers'),
  newCoins('New');

  const CryptoListType(this.value);
  final String value;
}

abstract class CryptoRemoteDataSource {
  /// GET /cryptolist?listType=All&page=1&limit=10
  Future<CryptoListResponseModel> fetchCryptoList({
    CryptoListType listType,
    int page,
    int limit,
  });

  /// GET /cryptolist?search=eth&page=1&limit=10
  Future<CryptoListResponseModel> searchCryptoList({
    required String search,
    int page,
    int limit,
  });

  /// GET /cryptoprofile?sym=bitcoin
  Future<CryptoProfileResponseModel> fetchCryptoProfile({
    required String sym,
  });
}