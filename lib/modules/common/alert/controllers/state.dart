sealed class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;

  NotificationSuccess(this.message);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}