import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<String, StockError> {
  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Stock.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'El campo es requerido';
    if (displayError == StockError.format) {
      return 'El campo es no tiene el formato esperado';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return StockError.empty;
    if (value.contains("'") || value.contains(" ")) return StockError.format;

    return null;
  }
}
