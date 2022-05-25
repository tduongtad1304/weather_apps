import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_apps/constants/constants.dart';

part 'background_images_state.dart';

class BackgroundImageCubit extends Cubit<BackgroundImageState> {
  BackgroundImageCubit() : super(BackgroundImageState.initial());

  void analyzeWeather(double currentTemp) {
    if (currentTemp > kCoolOrHot) {
      emit(state.copyWith(isHot: true));
    } else {
      emit(state.copyWith(isHot: false));
    }
  }
}
