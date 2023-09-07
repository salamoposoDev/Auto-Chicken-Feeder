class ImageHistory {
  final String image;
  final int time;

  ImageHistory({required this.image, required this.time});

  factory ImageHistory.fromJson(Map<String, dynamic> json) {
    return ImageHistory(
      image: json['image'],
      time: json['time'],
    );
  }
}
