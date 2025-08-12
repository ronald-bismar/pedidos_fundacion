class UUID {
  static String generateUUID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}