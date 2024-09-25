extension StringExt on String? {
  String get capitalizedFirstLetter {
    if (this?.isEmpty ?? true) {
      return "";
    }
    String firstLetter = this![0].toUpperCase();
    return firstLetter;
  }

  String get getMaskedEmail {
    if (this == null || this!.isEmpty) {
      return "";
    }
    return this!.replaceRange(3, this!.indexOf('@'), '****');
  }
}
