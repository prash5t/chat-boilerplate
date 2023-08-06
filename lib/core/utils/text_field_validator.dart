class TextFieldValidator {
  static phoneNumberValidator(number) {
    if (number.length > 15 || number.length < 5) {
      return "Invalid Phone number";
    }
    return null;
  }
}
