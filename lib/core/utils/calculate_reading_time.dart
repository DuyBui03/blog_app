int calculateReadingTime(String content) {
  final words = content.split(RegExp(r'\s+')).length;
  final wordsPerMinute = words / 225; // Average reading speed
  return wordsPerMinute.ceil();
}
