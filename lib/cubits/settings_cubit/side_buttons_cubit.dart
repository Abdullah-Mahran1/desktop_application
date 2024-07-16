import 'package:bloc/bloc.dart';

part 'side_buttons_state.dart';

class SideButtonsCubit extends Cubit<SideButtonsState> {
  SideButtonsCubit() : super(SideButtonDashboard());

  void navigate({required bool toSettings}) {
    if (toSettings) {
      emit(SideButtonSettings());
    } else {
      //Dashboard
      emit(SideButtonDashboard());
    }
  }

  bool get isSettings => state is SideButtonSettings;
}
