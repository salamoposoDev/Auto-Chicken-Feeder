class Sensors {
  int? feed;
  int? temp;
  int? humidity;
  int? time;
  int? feedTemp;

  Sensors({this.feed, this.temp, this.humidity, this.time, this.feedTemp});

  factory Sensors.fromJson(Map<String, dynamic> json) => Sensors(
        feed: json['feed'] ?? 0,
        temp: json['temp'] ?? 0,
        humidity: json['humidity'] ?? 0,
        time: json['time'] ?? 0,
        feedTemp: json['feedTemp'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'feed': feed,
        'temp': temp,
        'humidity': humidity,
        'time': time,
        'feedTemp': feedTemp,
      };
}
