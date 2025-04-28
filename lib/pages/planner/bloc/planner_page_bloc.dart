import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'planner_page_event.dart';
part 'planner_page_state.dart';

class PlannerPageBloc extends Bloc<PlannerPageEvent, PlannerPageState> {
  PlannerPageBloc() : super(PlannerPageInitial()) {
    on<PlannerPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
