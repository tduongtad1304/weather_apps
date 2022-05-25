import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double lattitude;
  final double longitude;
  final String weatherStateMain;
  final String weatherStateDescription;
  final String weatherStateIcon;
  final String destination;
  final double? tempMin;
  final double? tempMax;
  final double? temp;
  final double feelsLike;
  final int id;
  const Weather({
    required this.lattitude,
    required this.longitude,
    required this.weatherStateMain,
    required this.weatherStateDescription,
    required this.weatherStateIcon,
    required this.destination,
    required this.tempMin,
    required this.tempMax,
    required this.temp,
    required this.feelsLike,
    required this.id,
  });

  @override
  List<Object?> get props => [
        lattitude,
        longitude,
        weatherStateMain,
        weatherStateDescription,
        weatherStateIcon,
        destination,
        tempMin,
        tempMax,
        temp,
        feelsLike,
        id,
      ];

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final coord = json['coord'];
    final weather = json['weather'][0];

    return Weather(
      lattitude: coord['lat'],
      longitude: coord['lon'],
      weatherStateMain: weather['main'],
      weatherStateDescription: weather['description'],
      weatherStateIcon: weather['icon'],
      destination: json['name'],
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      temp: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      id: json['id'] as int,
    );
  }

  factory Weather.initial() => const Weather(
        lattitude: 0.0,
        longitude: 0.0,
        weatherStateMain: '',
        weatherStateDescription: '',
        weatherStateIcon: '',
        destination: '',
        tempMin: 0.0,
        tempMax: 0.0,
        temp: 0.0,
        feelsLike: 0.0,
        id: 00,
      );

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'lattitude': lattitude,
      'longitude': longitude,
      'weatherStateMain': weatherStateMain,
      'weatherStateDescription': weatherStateDescription,
      'weatherStateIcon': weatherStateIcon,
      'destination': destination,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'temp': temp,
      'feelsLike': feelsLike,
      'id': id,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      lattitude: map['lattitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      weatherStateMain: map['weatherStateMain'] ?? '',
      weatherStateDescription: map['weatherStateDescription'] ?? '',
      weatherStateIcon: map['weatherStateIcon'] ?? '',
      destination: map['destination'] ?? '',
      tempMin: map['tempMin']?.toDouble() ?? 0.0,
      tempMax: map['tempMax']?.toDouble() ?? 0.0,
      temp: map['temp']?.toDouble() ?? 0.0,
      feelsLike: map['feelsLike']?.toDouble() ?? 0.0,
      id: map['id']?.toInt() ?? 0,
    );
  }
}
