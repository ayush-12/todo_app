abstract class HomeState {}

class HomeInitial extends HomeState {}

class DrawerState extends HomeState {
  final bool shouldOpen;

  DrawerState({required this.shouldOpen});
}
