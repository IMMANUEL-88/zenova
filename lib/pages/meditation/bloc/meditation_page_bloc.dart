import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'meditation_page_event.dart';
part 'meditation_page_state.dart';

class MeditationPageBloc extends Bloc<MeditationPageEvent, MeditationPageState> {
  MeditationPageBloc() : super(MeditationPageInitial()) {
    on<MeditationPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
