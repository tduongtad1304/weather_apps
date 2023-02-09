import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String? destination;
  final double? temp;
  final double? tempMin;
  final double? tempMax;
  final String? weatherStateDescription;
  final String? weatherStateIcon;

  const Weather({
    required this.destination,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weatherStateDescription,
    required this.weatherStateIcon,
  });

  @override
  List<Object?> get props => [
        destination,
        temp,
        tempMin,
        tempMax,
        weatherStateDescription,
        weatherStateIcon,
      ];

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    return Weather(
      destination: json['name'] ?? '',
      temp: main['temp'] ?? 0.0,
      tempMin: main['temp_min'] ?? 0.0,
      tempMax: main['temp_max'] ?? 0.0,
      weatherStateDescription: weather['description'] ?? '',
      weatherStateIcon: weather['icon'] ?? '',
    );
  }

  factory Weather.initial() => const Weather(
        destination: '',
        temp: 0.0,
        tempMin: 0.0,
        tempMax: 0.0,
        weatherStateDescription: '',
        weatherStateIcon: '',
      );

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'temp': temp,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'weatherStateDescription': weatherStateDescription,
      'weatherStateIcon': weatherStateIcon,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      destination: map['destination'] ?? '',
      temp: map['temp']?.toDouble() ?? 0.0,
      tempMin: map['tempMin']?.toDouble() ?? 0.0,
      tempMax: map['tempMax']?.toDouble() ?? 0.0,
      weatherStateDescription: map['weatherStateDescription'] ?? '',
      weatherStateIcon: map['weatherStateIcon'] ?? '',
    );
  }
}
