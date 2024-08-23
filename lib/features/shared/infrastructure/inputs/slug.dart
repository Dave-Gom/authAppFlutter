import 'package:formz/formz.dart';

// Define input validation errors
enum SlugError { empty, value }

// Extend FormzInput and provide the input type and error type.
class Slug extends FormzInput<int, SlugError> {
  // Call super.pure to represent an unmodified form input.
  const Slug.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Slug.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SlugError.empty) return 'El campo es requerido';
    if (displayError == SlugError.value) {
      return 'Debe ser mayor a cero';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SlugError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return SlugError.empty;
    }

    if (value < 0) return SlugError.value;

    return null;
  }
}
