// User States
abstract class UserState {}

class UserInitial extends UserState {}

class UserCreated extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
