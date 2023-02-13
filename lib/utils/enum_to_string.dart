extension EnumToString on Enum {
  ///Extension method to convert [Enum] to [String].
  String enumToString() {
    return toString().split('.').last.split(')').first;
  }
}
