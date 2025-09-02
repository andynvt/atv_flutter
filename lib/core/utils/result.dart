/// Result class for handling success/error states
sealed class Result<T> {
  const Result();
}

/// Success result with data
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Error result with message
class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

/// Loading result
class Loading<T> extends Result<T> {
  const Loading();
}
