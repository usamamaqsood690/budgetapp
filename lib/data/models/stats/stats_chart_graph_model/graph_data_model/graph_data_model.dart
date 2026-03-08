class GraphData {
  final String label;
  final double volume;
  final double total;

  GraphData({
    required this.label,
    required this.volume,
     required this.total,
  });

  // Factory constructor to create from your JSON structure
  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      label: json['monthName'] ?? '',
      volume: ( json['volume'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),

    );
  }
}