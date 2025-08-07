int calculateReadingTime(String content) {
  final reg = RegExp(r'\s+');// Space or newline characters
  final wordCount = content.split(reg).length;
  final speed = 200;
  return (wordCount / speed).ceil();


}