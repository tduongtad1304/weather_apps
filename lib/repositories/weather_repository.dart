import 'package:weather_apps/exceptions/weather_exception.dart';
import 'package:weather_apps/models/custom_error.dart';
import 'package:weather_apps/services/services.dart';

import '../models/weather.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<Weather> fetchWeather(String cityName) async {
    try {
      final Weather weather = await weatherApiServices.getWeather(cityName);
      final weatherMap = Weather.fromMap(weather.toMap());
      return weatherMap;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
