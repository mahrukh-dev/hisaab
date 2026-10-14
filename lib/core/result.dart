sealed class Result<T> {
  const Result();

  factory Result.success(T value) => Success<T>(value);

  factory Result.failure(String message) => Failure<T>(message);
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;
}
