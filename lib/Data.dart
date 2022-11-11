class Data{
  final String? author;
  final String? title;
  final String? urlToImage;
  final String? publishedAt;

  const Data({required this.author, required this.title, required this.urlToImage, required this.publishedAt});

  factory Data.fromJson(Map<String,dynamic> json) {
    return Data(
      author: json['author']??'',
      title: json['title']??'',
      urlToImage: json['urlToImage']??'',
      publishedAt: 
      json['publishedAt']??'',
    );
  }
  
}