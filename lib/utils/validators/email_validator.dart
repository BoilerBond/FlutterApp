import 'package:datingapp/utils/validators/abstract_validator.dart';

class EmailValidator extends AbstractValidator {
  final String _invalidFormatMessage = "Please enter an email";
  final String _notPurdueMailMessage = "Please enter an Purdue email";

  @override
  String? validate(String? value, {bool validatePurdueEmail = false}) {
    if (value == null) {
      return _invalidFormatMessage;
    }

    final bool emailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value);

    if (validatePurdueEmail) {
      final bool isPurdueEmail = RegExp(r"^[a-zA-Z0-9._%+-]+@purdue\.edu$").hasMatch(value);

      if (emailValid && !isPurdueEmail) {
        return _notPurdueMailMessage;
      }
    }
    return emailValid ? null : _invalidFormatMessage;
  }
}
