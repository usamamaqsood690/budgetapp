class StockDetailEntity {
  final String symbol;
  final String name;
  final String exchange;
  final double price;
  final double changesPercentage;
  final double change;
  final double dayLow;
  final double dayHigh;
  final double open;
  final double previousClose;
  final double marketCap;
  final double volume;
  final double averageVolume;
  final double sharesOutstanding;
  final double lastDividend;
  final String range;
  final String image;
  final String description;
  final double changeOvertime;
  final double perRange;
  final double divYield;
  final String twentyFourHRange;
  final double turnover;

  const StockDetailEntity({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.price,
    required this.changesPercentage,
    required this.change,
    required this.dayLow,
    required this.dayHigh,
    required this.open,
    required this.previousClose,
    required this.marketCap,
    required this.volume,
    required this.averageVolume,
    required this.sharesOutstanding,
    required this.lastDividend,
    required this.range,
    required this.image,
    required this.description,
    required this.changeOvertime,
    required this.perRange,
    required this.divYield,
    required this.twentyFourHRange,
    required this.turnover,
  });
}