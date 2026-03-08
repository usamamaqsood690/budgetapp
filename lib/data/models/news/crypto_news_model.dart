import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';

class CryptoNewsModel {
  final String? url;
  final String? createdAt;
  final String? fetchedAt;
  final String? image;
  final String? publishedDate;
  final String? publisher;
  final String? site;
  final String? symbol;
  final String? text;
  final String? title;
  final String? type;
  final String? updatedAt;

  CryptoNewsModel({
    this.url,
    this.createdAt,
    this.fetchedAt,
    this.image,
    this.publishedDate,
    this.publisher,
    this.site,
    this.symbol,
    this.text,
    this.title,
    this.type,
    this.updatedAt,
  });

  factory CryptoNewsModel.fromJson(Map<String, dynamic> json) {
    return CryptoNewsModel(
      url: json['url'] as String?,
      createdAt: json['createdAt'] as String?,
      fetchedAt: json['fetchedAt'] as String?,
      image: json['image'] as String?,
      publishedDate: json['publishedDate'] as String?,
      publisher: json['publisher'] as String?,
      site: json['site'] as String?,
      symbol: json['symbol'] as String?,
      text: json['text'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'createdAt': createdAt,
      'fetchedAt': fetchedAt,
      'image': image,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'site': site,
      'symbol': symbol,
      'text': text,
      'title': title,
      'type': type,
      'updatedAt': updatedAt,
    };
  }

  /// Convert Model to Entity
  NewsEntity toEntity() {
    return NewsEntity(
      url: url,
      image: image,
      publishedDate: publishedDate,
      publisher: publisher,
      site: site,
      symbol: symbol,
      text: text,
      title: title,
      type: type,
    );
  }

  /// Create Model from Entity
  factory CryptoNewsModel.fromEntity(NewsEntity entity) {
    return CryptoNewsModel(
      url: entity.url,
      image: entity.image,
      publishedDate: entity.publishedDate,
      publisher: entity.publisher,
      site: entity.site,
      symbol: entity.symbol,
      text: entity.text,
      title: entity.title,
      type: entity.type,
    );
  }

  @override
  String toString() {
    return 'CryptoNewsModel(title: $title, publisher: $publisher, publishedDate: $publishedDate)';
  }
}

/// Response wrapper for the news API
class NewsResponseModel {
  final bool status;
  final String message;
  final NewsBodyModel? body;

  NewsResponseModel({
    required this.status,
    required this.message,
    this.body,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      body: json['body'] != null
          ? NewsBodyModel.fromJson(json['body'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'body': body?.toJson(),
    };
  }

  /// Get list of news models from response
  List<CryptoNewsModel> get news => body?.data ?? [];
}

/// Body wrapper containing the data array
class NewsBodyModel {
  final List<CryptoNewsModel> data;
  final String? source;
  final bool refreshing;

  NewsBodyModel({
    required this.data,
    this.source,
    this.refreshing = false,
  });

  factory NewsBodyModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return NewsBodyModel(
      data: dataList
          .map((item) => CryptoNewsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String?,
      refreshing: json['refreshing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'source': source,
      'refreshing': refreshing,
    };
  }
}