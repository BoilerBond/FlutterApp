import 'package:datingapp/utils/validators/abstract_validator.dart';

class PasswordValidator extends AbstractValidator {
  final int _minimumLength = 8;
  late final String _invalidLengthMessage = "Minimum of $_minimumLength characters required";
  late final String _noLowerCaseMessage = "Password must contain at least 1 lower case character";
  late final String _noUpperCaseMessage = "Password must contain at least 1 upper case character";
  late final String _noNumberMessage = "Password must contain at least 1 number character";
  late final String _noValidSpecialCharacterMessage = "Password must contain at least 1 valid special character";
  late final String _invalidCharacterExistMessage = "Password contains invalid characters";

  @override
  String? validate(String? value, {bool validatePurdueEmail = false}) {
    if (value == null || value.isEmpty || value.length < _minimumLength) {
      return _invalidLengthMessage;
    }

    // if the password does not have a lowercase character
    if (!RegExp(r"[a-z]+").hasMatch(value)) {
      return _noLowerCaseMessage;
    }

    // if the password does not have a uppercase character
    if (!RegExp(r"[A-Z]+").hasMatch(value)) {
      return _noUpperCaseMessage;
    }

    // if the password does not have a number character
    if (!RegExp(r"[0-9]+").hasMatch(value)) {
      return _noNumberMessage;
    }

    // if the password does not have a valid special character
    if (!RegExp(r"[!@#$%^&*()_\+=|\\\.?/~-]+").hasMatch(value)) {
      return _noValidSpecialCharacterMessage;
    }

    // if the password does not have a valid special character
    if (!RegExp(r"[!@#$%^&*()_\+=|\\\.?/~-]+").hasMatch(value)) {
      return _noValidSpecialCharacterMessage;
    }

    // if the password does not have a valid special character
    if (RegExp(r"[^a-zA-z0-9!@#$%^&*()_\+=|\\\.?/~-]+").hasMatch(value)) {
      return _invalidCharacterExistMessage;
    }

    return null;
  }
}
