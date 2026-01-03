sealed class Result<S, E extends HttpException> {
  const Result();
}

final class Success<S, E extends HttpException> extends Result<S, E> {
const Success(this.value);
final S value;
}

final class Failure<S, E extends HttpException> extends Result<S, E> {
const Failure(this.exception);
final E exception;
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);  // Pass your message in constructor. 

  @override
  String toString() {
    return message;
  }
}