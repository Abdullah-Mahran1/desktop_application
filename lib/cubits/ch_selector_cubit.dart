import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ch_selector_state.dart';

class ChSelectorCubit extends Cubit<ChSelectorState> {
  ChSelectorCubit() : super(ChSelectorInitial());
}
