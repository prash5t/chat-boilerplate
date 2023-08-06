String returnTextOfThisLength({required String text, required int length}) {
  if (text.length <= length) {
    return text;
  }

  final textToReturn = text.substring(0, length - 3) + "...";
  return textToReturn;
}
