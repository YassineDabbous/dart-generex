extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get toPlural {
    if (endsWith('y')) {
      return replaceRange(length - 1, null, 'ies');
      // return '${this}ies';
    }
    if (endsWith('s')) {
      return '${this}es';
    }
    if (endsWith('h')) {
      return '${this}es';
    }
    return '${this}s';
  }

  String get asValueHolder {
    return replaceAll('Id', '');
  }
}
