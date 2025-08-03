part of 'habit_track_page_bloc.dart';

@immutable
sealed class HabitTrackPageState {}

sealed class HabitTrackPageActionState extends HabitTrackPageState {}

final class HabitTrackPageInitial extends HabitTrackPageState {}

final class HabitTrackPageLoadingState extends HabitTrackPageState {}

final class HabitTrackPageLoadedState extends HabitTrackPageState {
  // final List<String> habitList;
  // final DateTime? firstDay;

  // HabitTrackPageLoadedState({required this.habitList, required this.firstDay});
}

final class HabitTrackPageErrorState extends HabitTrackPageState {
  final String errorMessage;

  HabitTrackPageErrorState({required this.errorMessage});
}

final class HabitTrackPageAddHabitConfirmState extends HabitTrackPageState {}

final class HabitTrackPageHabitBoxDeleteConfirmState
    extends HabitTrackPageState {}

// Action State
final class HabitTrackPageLogoutPressedState
    extends HabitTrackPageActionState {}

final class HabitTrackPageHabitBoxOnPressedState
    extends HabitTrackPageActionState {}

final class HabitTrackPageHabitBoxEditPressedState
    extends HabitTrackPageActionState {}

final class HabitTrackPageHabitBoxDeletePressedState
    extends HabitTrackPageActionState {}

final class HabitTrackPageAddHabitPressedState
    extends HabitTrackPageActionState {}
