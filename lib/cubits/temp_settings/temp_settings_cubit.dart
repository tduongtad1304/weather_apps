import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_settings_state.dart';

class TempSettingsCubit extends Cubit<TempSettingsState> {
  TempSettingsCubit() : super(TempSettingsState.initial());

  void toggleTempUnit() {
    if (state.tempUnit == TempUnit.Celsius) {
      emit(state.copyWith(tempUnit: TempUnit.Fahrenheit));
    } else {
      emit(state.copyWith(tempUnit: TempUnit.Celsius));
    }
  }
}
