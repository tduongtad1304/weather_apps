import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_apps/repositories/weather_repository.dart';

import '../../models/custom_error.dart';
import '../../models/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeather(String cityName) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      await weatherRepository.fetchWeather(cityName).then((weather) {
        emit(state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ));
      });
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
    }
  }
}
