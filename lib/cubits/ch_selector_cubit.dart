import 'package:bloc/bloc.dart';

part 'ch_selector_state.dart';

class ChSelectorCubit extends Cubit<ChSelectorState> {
  List<bool> selectedChannels = [true, true, false, false];

  ChSelectorCubit() : super(ChSelectorInitial());

  void updateChannels() {
    emit(ChSelectorUpdated());
  }
}
