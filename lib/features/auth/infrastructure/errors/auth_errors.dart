class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomeError implements Exception {
  final String message;
  final bool loggedRequired;
  CustomeError(this.message, [this.loggedRequired = false]);
}
