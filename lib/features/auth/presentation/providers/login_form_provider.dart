import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

class LoginFormState {
  final bool isPosting;
  final bool isPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
        email: email ?? this.email,
        isPosted: isPosted ?? this.isPosted,
        isPosting: isPosting ?? this.isPosting,
        isValid: isValid ?? this.isValid,
        password: password ?? this.password);
  }

  @override
  String toString() {
    return '''
  isPosting: $isPosting
  isPosted: $isPosted
  isValid: $isValid
  email: $email
''';
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPass = Password.dirty(value);
    state = state.copyWith(
        password: newPass, isValid: Formz.validate([newPass, state.email]));
  }

  onFormSubmit() {
    _touchEveryField();
    print(state.toString());
    if (!state.isValid) {
      return;
    }
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        email: email,
        password: password,
        isPosted: true,
        isValid: Formz.validate([email, password]));
  }
}
