class Photo {
  String type;
  String name;
  String url;

  Photo({
    required this.type,
    required this.name,
    required this.url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      type: json['__type'],
      name: json['name'],
      url: json['url'],
    );
  }
}
