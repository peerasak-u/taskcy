import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit() : super(TaskListInitial());

  void initialize({required String taskType, DateTime? initialDate}) {
    emit(TaskListLoaded(
      viewMode: TaskListViewMode.timeline,
      selectedDate: initialDate ?? DateTime.now(),
      taskType: taskType,
    ));
  }

  void toggleViewMode() {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final newViewMode = currentState.viewMode == TaskListViewMode.timeline
          ? TaskListViewMode.calendar
          : TaskListViewMode.timeline;
      
      emit(currentState.copyWith(viewMode: newViewMode));
    }
  }

  void selectDate(DateTime date) {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  void updateTaskType(String taskType) {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(currentState.copyWith(taskType: taskType));
    }
  }
}