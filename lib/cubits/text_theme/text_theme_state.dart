// ignore_for_file: constant_identifier_names

part of 'text_theme_cubit.dart';

enum TextThemes {
  Light,
  Dark,
}

class TextThemeState extends Equatable {
  final TextThemes textTheme;
  const TextThemeState({
    required this.textTheme,
  });

  @override
  List<Object> get props => [textTheme];

  factory TextThemeState.initial() =>
      const TextThemeState(textTheme: TextThemes.Light);

  TextThemeState copyWith({
    TextThemes? textTheme,
  }) {
    return TextThemeState(
      textTheme: textTheme ?? this.textTheme,
    );
  }

  @override
  String toString() => 'TextThemeState(textTheme: $textTheme)';
}
