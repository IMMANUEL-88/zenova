import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'zenfocus_page_event.dart';
part 'zenfocus_page_state.dart';

class ZenfocusPageBloc extends Bloc<ZenfocusPageEvent, ZenfocusPageState> {
  ZenfocusPageBloc() : super(ZenfocusPageInitial()) {
    on<ZenfocusPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
