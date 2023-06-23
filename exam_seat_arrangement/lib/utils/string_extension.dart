extension StringExtension on String {
  String titleCase() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
