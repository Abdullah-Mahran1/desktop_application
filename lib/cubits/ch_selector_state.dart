part of 'ch_selector_cubit.dart';

@immutable
sealed class ChSelectorState {}

final class ChSelectorInitial extends ChSelectorState {}



/*
Steps for building a cubit:

1. Write states
2. Write cubit functions,  variables & emits
3. Provide it to UI trigger - BlocProvider
4. use it in UI - BlocConsumer
*/
