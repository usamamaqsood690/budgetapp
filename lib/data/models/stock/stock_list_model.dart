import 'package:wealthnxai/domain/entities/stock/stock_entity.dart';

class StockListResponseModel {
  final bool? status;
  final String? message;
  final List<StockItemModel> data;

  StockListResponseModel({
    this.status,
    this.message,
    required this.data,
  });

  factory StockListResponseModel.fromJson(Map<String, dynamic> json) {
    return StockListResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['body'] as List<dynamic>?)  // ← 'body' not 'data'
          ?.map((e) => StockItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class StockItemModel {
  final String symbol;
  final String name;
  final String price;
  final String changesPercentage;
  final String image;

  StockItemModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changesPercentage,
    required this.image,
  });

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      changesPercentage: json['changesPercentage']?.toString() ?? '0',
      image: json['image']?.toString() ?? '',
    );
  }

  StockEntity toEntity() {
    return StockEntity(
      symbol: symbol,
      name: name,
      price: price,
      changePercentage: changesPercentage,
      imageUrl: image,
    );
  }
}