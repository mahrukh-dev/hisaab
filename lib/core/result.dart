sealed class Result<T> {
  const Result();

  factory Result.success(T value) => Success<T>(value);

  factory Result.failure(String message) => Failure<T>(message);

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>() => null,
      };

  T get value => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>(:final message) => throw StateError(message),
      };

  String? get messageOrNull => switch (this) {
        Success<T>() => null,
        Failure<T>(:final message) => message,
      };
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;
}
