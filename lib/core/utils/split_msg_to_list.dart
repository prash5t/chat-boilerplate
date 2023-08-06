List<String> splitMessageIntoSentences(String message) {
  const int maxMessageLength = 150;

  List<String> sentences = message.split(RegExp(r'[\.:]'));

  // when msg is short, in that case just returning the original msg
  if (message.length <= maxMessageLength || sentences.length <= 1) {
    return [message];
  }

  List<String> result = [];
  String currentMessage = '';

  for (int index = 0; index < sentences.length; index++) {
    String sentence = sentences[index].trim();

    if (sentence.isNotEmpty) {
      // If adding the current sentence exceeds the maximum message length, add the current message to the result list
      // and start a new message with the current sentence
      if ((currentMessage + sentence).length > maxMessageLength) {
        result.add(currentMessage);
        currentMessage = sentence;
      }
      // Otherwise, add the current sentence to the current message
      else {
        currentMessage += ' ${sentence}';
      }
    }
  }

  // Add the last message to the result list
  if (currentMessage.isNotEmpty) {
    result.add(currentMessage.trim());
  }

  return result;
}
