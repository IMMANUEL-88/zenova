part of 'habit_track_page_bloc.dart';

@immutable
sealed class HabitTrackPageEvent {}

final class HabitTrackPageInitialEvent extends HabitTrackPageEvent {}

final class HabitTrackPageListTileOnPressedEvent extends HabitTrackPageEvent {
  final String route;
  final BuildContext context;

  HabitTrackPageListTileOnPressedEvent({
    required this.route,
    required this.context,
  });
}

final class HabitTrackPageLogoutPressedEvent extends HabitTrackPageEvent {}
