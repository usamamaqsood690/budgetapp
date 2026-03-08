// lib/domain/entities/crypto/crypto_coin_entity.dart

class CryptoCoinEntity {
  final String? id;
  final String? symbol;
  final String? name;
  final String? description;
  final String? image;
  final String? currentPrice;
  final String? marketCap;
  final String? fdv;
  final String? totalVolume;
  final String? high24h;
  final String? low24h;
  final String? priceChangesPer24h;
  final String? marketCapPer24h;
  final String? marketCapChangePer24h;
  final String? circulatingSupply;
  final String? totalSupply;
  final String? maxSupply;
  final String? ath;
  final String? athDate;
  final String? atl;
  final String? atlDate;

  const CryptoCoinEntity({
    this.id,
    this.symbol,
    this.name,
    this.description,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.fdv,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChangesPer24h,
    this.marketCapPer24h,
    this.marketCapChangePer24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athDate,
    this.atl,
    this.atlDate,
  });

  double get priceChangePercentage24h =>
      double.tryParse(priceChangesPer24h ?? '0') ?? 0.0;

  double get currentPriceDouble =>
      double.tryParse(currentPrice ?? '0') ?? 0.0;
}