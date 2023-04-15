class Result<T> {
  final T? _value;
  final String? _error;

  Result._(this._value, this._error);

  bool get isSuccess => _error == null;
  bool get isFailure => _error != null;

  T get success {
    if (isSuccess) {
      return _value!;
    }
    throw StateError('Cannot get success value from a failure result.');
  }

  String get failure {
    if (isFailure) {
      return _error!;
    }
    throw StateError('Cannot get failure value from a success result.');
  }

  factory Result.success(T value) => Result._(value, null);

  factory Result.failure(String error) => Result._(null, error);

  R fold<R>(R Function(String) onFail, R Function(T) onSuccess) {
    if (isFailure) {
      return onFail(failure);
    } else {
      return onSuccess(success);
    }
  }
}
