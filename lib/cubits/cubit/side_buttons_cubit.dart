import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'side_buttons_state.dart';

class SideButtonsCubit extends Cubit<SideButtonsState> {
  SideButtonsCubit() : super(SideButtonDashboard());

  void navigate({required bool toSettings}) {
    if (toSettings) {
      emit(SideButtonSetings());
    } else {
      //Dashboard
      emit(SideButtonDashboard());
    }
  }
}
