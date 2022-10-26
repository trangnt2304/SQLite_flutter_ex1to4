class ImageUrl {
  String imageUrl;

  ImageUrl({
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
        'imageUrl': imageUrl,
      };

  factory ImageUrl.fromMap(Map<String, dynamic> map) {
    return ImageUrl(
      imageUrl: map['imageUrl'],
    );
  }

  @override
  String toString() {
    return 'Image Url: $imageUrl}';
  }
}
