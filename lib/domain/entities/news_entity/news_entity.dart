/// News Entity - Domain Layer
/// Located in: lib/domain/entities/news_entity/news_entity.dart

class NewsEntity {
  final String? url;
  final String? image;
  final String? publishedDate;
  final String? publisher;
  final String? site;
  final String? symbol;
  final String? text;
  final String? title;
  final String? type;

  const NewsEntity({
    this.url,
    this.image,
    this.publishedDate,
    this.publisher,
    this.site,
    this.symbol,
    this.text,
    this.title,
    this.type,
  });

  NewsEntity copyWith({
    String? url,
    String? image,
    String? publishedDate,
    String? publisher,
    String? site,
    String? symbol,
    String? text,
    String? title,
    String? type,
  }) {
    return NewsEntity(
      url: url ?? this.url,
      image: image ?? this.image,
      publishedDate: publishedDate ?? this.publishedDate,
      publisher: publisher ?? this.publisher,
      site: site ?? this.site,
      symbol: symbol ?? this.symbol,
      text: text ?? this.text,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'image': image,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'site': site,
      'symbol': symbol,
      'text': text,
      'title': title,
      'type': type,
    };
  }

  factory NewsEntity.fromJson(Map<String, dynamic> json) {
    return NewsEntity(
      url: json['url'] as String?,
      image: json['image'] as String?,
      publishedDate: json['publishedDate'] as String?,
      publisher: json['publisher'] as String?,
      site: json['site'] as String?,
      symbol: json['symbol'] as String?,
      text: json['text'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewsEntity &&
              runtimeType == other.runtimeType &&
              url == other.url &&
              title == other.title;

  @override
  int get hashCode => Object.hash(url, title);

  @override
  String toString() {
    return 'NewsEntity(title: $title, publisher: $publisher, type: $type)';
  }
}