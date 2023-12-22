abstract class Failure implements Exception {
  String? mesaage;
  Failure(this.mesaage);
}

class FetechFailure extends Failure {
  FetechFailure(super.mesaage);
}

class BadRequestFailure extends Failure {
  BadRequestFailure(super.mesaage);
}

class UnauthorisedFailure extends Failure {
  UnauthorisedFailure(super.mesaage);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure(super.mesaage);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(super.mesaage);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.mesaage);
}

class ServerFailure extends Failure {
  ServerFailure(super.mesaage);
}
