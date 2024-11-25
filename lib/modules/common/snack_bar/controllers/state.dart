import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;

  NotificationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);

  @override
  List<Object> get props => [message];
}