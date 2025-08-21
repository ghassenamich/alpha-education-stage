import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/school_entity.dart';
import '../../domain/usecases/get_tutor_history_usecase.dart';

part 'tutor_history_state.dart';

class TutorHistoryCubit extends Cubit<TutorHistoryState> {
  final GetTutorHistoryUseCase useCase;

  TutorHistoryCubit(this.useCase) : super(TutorHistoryInitial());

  Future<void> loadTutorHistory() async {
    emit(TutorHistoryLoading());
    try {
      final schools = await useCase(); // now returns List<SchoolEntity>
      emit(TutorHistoryLoaded(schools));
    } catch (e, st) {
      print('❌ TutorHistoryCubit error: $e');
      print('$st');
      emit(TutorHistoryError("Failed loading: ${e.toString()}"));
    }
  }
}
