part of 'side_buttons_cubit.dart';

@immutable
sealed class SideButtonsState {}

final class SideButtonDashboard extends SideButtonsState {}

final class SideButtonSetings extends SideButtonsState {}






/*
Steps for building a cubit:

1. Write states
2. Write cubit functions,  variables & emits
3. Provide it to UI trigger - BlocProvider
4. use it in UI - BlocConsumer
*/
