import 'dart:math';

int getRandomNumber() {
  final random = Random();
  return random.nextInt(121);
  // final randomNumber = random.nextDouble();

  // if (randomNumber < 0.45) {
  //   // 45% probability for numbers 1 to 10
  //   return random.nextInt(10) + 1;
  // } else if (randomNumber < 0.75) {
  //   // 30% probability for numbers 11 to 50
  //   return random.nextInt(40) + 11;
  // } else {
  //   // 25% probability for numbers 51 to 120
  //   return random.nextInt(70) + 51;
  // }
}
