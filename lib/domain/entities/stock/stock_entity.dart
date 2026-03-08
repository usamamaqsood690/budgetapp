class StockEntity {
  final String symbol;
  final String name;
  final String price;
  final String changePercentage;
  final String imageUrl;

  StockEntity({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercentage,
    required this.imageUrl,
  });
}