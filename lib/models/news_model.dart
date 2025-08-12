class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String publishedAt;
  final String sourceName;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? json['imageUrl'],
      publishedAt: json['publishedAt'] ?? '',
      sourceName: (json['source'] is Map<String, dynamic>)
          ? (json['source']['name'] ?? '')
          : (json['sourceName'] ?? json['source'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'sourceName': sourceName,
    };
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(publishedAt);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return publishedAt;
    }
  }
}

class NewsResponse {
  final List<NewsArticle> articles;
  final int totalResults;

  NewsResponse({required this.articles, required this.totalResults});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    final articlesList = (json['articles'] as List<dynamic>? ?? []);
    return NewsResponse(
      articles: articlesList
          .map(
            (article) => NewsArticle.fromJson(article as Map<String, dynamic>),
          )
          .toList(),
      totalResults: json['totalResults'] ?? 0,
    );
  }
}
