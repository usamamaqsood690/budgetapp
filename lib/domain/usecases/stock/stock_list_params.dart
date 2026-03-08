class StockListParams {
  final String listType;
  final String? search;
  final int page;
  final int limit;

  StockListParams({
    this.listType = 'All',
    this.search,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'listType': listType,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search!.isNotEmpty) {
      params['search'] = search!;
    }
    return params;
  }
}