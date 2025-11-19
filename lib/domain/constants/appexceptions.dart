class AppExceptions implements Exception {
  final String errormsg;
  AppExceptions({required this.errormsg});

  @override
  String toString() {
    return errormsg;
  }

  String toErrormsg() {
    return toString();
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException({required super.errormsg});
}

class BadRequestException extends AppExceptions {
  BadRequestException({required super.errormsg});
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException({required super.errormsg});
}

class InvalidInputException extends AppExceptions {
  InvalidInputException({required super.errormsg});
}