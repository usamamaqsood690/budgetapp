import 'package:wealthnxai/domain/entities/stock/stock_detail_entity.dart';

class StockDetailModel extends StockDetailEntity {
  const StockDetailModel({
    required super.symbol,
    required super.name,
    required super.exchange,
    required super.price,
    required super.changesPercentage,
    required super.change,
    required super.dayLow,
    required super.dayHigh,
    required super.open,
    required super.previousClose,
    required super.marketCap,
    required super.volume,
    required super.averageVolume,
    required super.sharesOutstanding,
    required super.lastDividend,
    required super.range,
    required super.image,
    required super.description,
    required super.changeOvertime,
    required super.perRange,
    required super.divYield,
    required super.twentyFourHRange,
    required super.turnover,
  });

  factory StockDetailModel.fromJson(Map<String, dynamic> json) {
    // Response wraps the stock object inside "body"
    final body = json['body'] as Map<String, dynamic>? ?? json;

    return StockDetailModel(
      symbol: body['symbol'] as String? ?? '',
      name: body['name'] as String? ?? '',
      exchange: body['exchange'] as String? ?? '',
      price: _parseDouble(body['price']),
      changesPercentage: _parseDouble(body['changesPercentage']),
      change: _parseDouble(body['change']),
      dayLow: _parseDouble(body['dayLow']),
      dayHigh: _parseDouble(body['dayHigh']),
      open: _parseDouble(body['open']),
      previousClose: _parseDouble(body['previousClose']),
      marketCap: _parseDouble(body['marketCap']),
      volume: _parseDouble(body['volume']),
      averageVolume: _parseDouble(body['averageVolume']),
      sharesOutstanding: _parseDouble(body['sharesOutstanding']),
      lastDividend: _parseDouble(body['lastDividend']),
      range: body['range'] as String? ?? '',
      image: body['image'] as String? ?? '',
      description: body['description'] as String? ?? '',
      changeOvertime: _parseDouble(body['changeOvertime']),
      perRange: _parseDouble(body['perRange']),
      divYield: _parseDouble(body['divYeild']), // typo is in the API response
      twentyFourHRange: body['24hRange'] as String? ?? '',
      turnover: _parseDouble(body['turnover']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}