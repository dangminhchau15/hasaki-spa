class Validation {
  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^(0)([0-9]){9}$|^(\+)([0-9]){11}$');
    return regexPhone.hasMatch(phone);
  }

  static isEmailValid(String email) {
    final regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regexEmail.hasMatch(email);
  }

  static isPassValid(String pass) {
    return pass.length >= 8;
  }

  static isDisplayNameValid(String displayName) {
    return displayName.length > 5;
  }
}