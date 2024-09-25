extension StringExt on String? {
  String get capitalizedFirstLetter {
    if (this?.isEmpty ?? true) {
      return "";
    }
    String firstLetter = this![0].toUpperCase();
    return firstLetter;
  }
}
