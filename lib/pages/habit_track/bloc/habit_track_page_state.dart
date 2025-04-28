part of 'habit_track_page_bloc.dart';

@immutable
sealed class HabitTrackPageState {}

sealed class HabitTrackPageActionState extends HabitTrackPageState {}

final class HabitTrackPageInitial extends HabitTrackPageState {}

final class HabitTrackPageLoadingState extends HabitTrackPageState {}

final class HabitTrackPageLoadedState extends HabitTrackPageState {}

final class HabitTrackPageErrorState extends HabitTrackPageState {
  final String errorMessage;

  HabitTrackPageErrorState({required this.errorMessage});
}

// Action State
final class HabitTrackPageLogoutPressedState
    extends HabitTrackPageActionState {}
