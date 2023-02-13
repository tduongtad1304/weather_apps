// ignore_for_file: constant_identifier_names

part of 'temp_settings_cubit.dart';

enum TempUnit {
  Celsius,
  Fahrenheit,
}

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;
  const TempSettingsState({
    this.tempUnit = TempUnit.Celsius,
  });

  factory TempSettingsState.initial() {
    return const TempSettingsState();
  }

  @override
  List<Object> get props => [tempUnit];

  @override
  bool get stringify => true;

  TempSettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }

  @override
  String toString() => 'TempSettingsState(tempUnit: $tempUnit)';
}
