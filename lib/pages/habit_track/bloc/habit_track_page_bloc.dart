import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'habit_track_page_event.dart';
part 'habit_track_page_state.dart';

class HabitTrackPageBloc
    extends Bloc<HabitTrackPageEvent, HabitTrackPageState> {
  HabitTrackPageBloc() : super(HabitTrackPageInitial()) {
    on<HabitTrackPageInitialEvent>(habitTrackPageInitialEvent);
    on<HabitTrackPageListTileOnPressedEvent>(
        habitTrackPageListTileOnPressedEvent);
    on<HabitTrackPageLogoutPressedEvent>(habitTrackPageLogoutPressedEvent);
  }

  FutureOr<void> habitTrackPageInitialEvent(HabitTrackPageInitialEvent event,
      Emitter<HabitTrackPageState> emit) async {
    // emit(HabitTrackPageLoadingState());
    // await Future.delayed(Duration(seconds: 3));
    emit(HabitTrackPageLoadedState());
  }

  FutureOr<void> habitTrackPageListTileOnPressedEvent(
      HabitTrackPageListTileOnPressedEvent event,
      Emitter<HabitTrackPageState> emit) {
    event.context.push(event.route);
  }

  FutureOr<void> habitTrackPageLogoutPressedEvent(
      HabitTrackPageLogoutPressedEvent event,
      Emitter<HabitTrackPageState> emit) {
    emit(HabitTrackPageLogoutPressedState());
  }
}
