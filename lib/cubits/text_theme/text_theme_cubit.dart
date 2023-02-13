import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_theme_state.dart';

class TextThemeCubit extends Cubit<TextThemeState> {
  TextThemeCubit() : super(TextThemeState.initial());

  void changeTextTheme() {
    if (state.textTheme == TextThemes.Dark) {
      emit(state.copyWith(textTheme: TextThemes.Light));
    } else {
      emit(state.copyWith(textTheme: TextThemes.Dark));
    }
  }
}
