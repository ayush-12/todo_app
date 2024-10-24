import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> handleDrawer(bool shouldOpen) async {
    emit(DrawerState(shouldOpen: shouldOpen));
  }
}
