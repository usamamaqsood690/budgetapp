// lib/data/models/crypto/crypto_coin_model.dart

import 'package:wealthnxai/domain/entities/crypto/crypto_coin_entity.dart';

class CryptoCoinModel extends CryptoCoinEntity {
  const CryptoCoinModel({
    super.id,
    super.symbol,
    super.name,
    super.description,
    super.image,
    super.currentPrice,
    super.marketCap,
    super.fdv,
    super.totalVolume,
    super.high24h,
    super.low24h,
    super.priceChangesPer24h,
    super.marketCapPer24h,
    super.marketCapChangePer24h,
    super.circulatingSupply,
    super.totalSupply,
    super.maxSupply,
    super.ath,
    super.athDate,
    super.atl,
    super.atlDate,
  });

  factory CryptoCoinModel.fromJson(Map<String, dynamic> json) {
    return CryptoCoinModel(
      id: json['id']?.toString(),
      symbol: json['symbol']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      currentPrice: json['currentPrice']?.toString(),
      marketCap: json['marketCap']?.toString(),
      fdv: json['fdv']?.toString(),
      totalVolume: json['totalVolumn']?.toString(), // API typo: "totalVolumn"
      high24h: json['24hHigh']?.toString(),
      low24h: json['24hLow']?.toString(),
      priceChangesPer24h: json['priceChangesPer24h']?.toString(),
      marketCapPer24h: json['marketCapPer24h']?.toString(),
      marketCapChangePer24h: json['marketCapChangePer24h']?.toString(),
      circulatingSupply: json['circulatingSupply']?.toString(),
      totalSupply: json['totalSupply']?.toString(),
      maxSupply: json['maxSupply']?.toString(),
      ath: json['ath']?.toString(),
      athDate: json['athDate']?.toString(),
      atl: json['atl']?.toString(),
      atlDate: json['atlDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'name': name,
    'description': description,
    'image': image,
    'currentPrice': currentPrice,
    'marketCap': marketCap,
    'fdv': fdv,
    'totalVolumn': totalVolume,
    '24hHigh': high24h,
    '24hLow': low24h,
    'priceChangesPer24h': priceChangesPer24h,
    'marketCapPer24h': marketCapPer24h,
    'marketCapChangePer24h': marketCapChangePer24h,
    'circulatingSupply': circulatingSupply,
    'totalSupply': totalSupply,
    'maxSupply': maxSupply,
    'ath': ath,
    'athDate': athDate,
    'atl': atl,
    'atlDate': atlDate,
  };
}