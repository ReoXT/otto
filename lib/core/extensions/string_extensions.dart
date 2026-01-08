extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String toTitleCase() {
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailRegex.hasMatch(this);
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    if (maxLength <= 3) return substring(0, maxLength);
    return '${substring(0, maxLength - 3).trimRight()}...';
  }
}
