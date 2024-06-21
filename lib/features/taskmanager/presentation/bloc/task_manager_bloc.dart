import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/add_new_todo_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_all_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_more_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/save_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/todo_validator.dart';

part 'task_manager_event.dart';

part 'task_manager_state.dart';

const NETWORK_ERROR = "Check your internet connection";
const SOMETHING_WENT_WRONG = "Something went wrong";

class TaskManagerBloc extends Bloc<TaskManagerEvent, TaskManagerState> {
  final GetAllTodosUseCase getAllTodoUsecase;
  final AddNewTodoUsecase addNewTodoUsecase;
  final GetLoggedInUserUsecase getLoggedInUserUsecase;
  final GetMoreTodosUsecase getMoreTodosUsecase;
  final SaveTodosUsecase saveTodosUseCase;
  final TodoValidator validator;

  TaskManagerBloc(
      this.getAllTodoUsecase,
      this.addNewTodoUsecase,
      this.getLoggedInUserUsecase,
      this.saveTodosUseCase,
      this.getMoreTodosUsecase,
      this.validator)
      : super(TaskManagerStateInitial()) {
    on<TaskManagerInitial>(_onLoadTodos);
    on<TaskManagerAddTodo>(_onAddTodo);
    on<TaskManagerDeleteTodo>(_onDeleteTodo);
    on<TaskManagerEditTodo>(_onEditTodo);
    on<TaskManagerClearStates>(_onClearStates);
    on<TaskManagerGetTodos>(_onLoadMoreTodos);
  }

  Future<void> _onLoadTodos(
      TaskManagerInitial event, Emitter<TaskManagerState> emit) async {
    emit(TaskManagerStateLoading());
    try {
      final todosResult = await getAllTodoUsecase(
          params: const GetAllTodosParams(limit: 30, offset: 0));

      await todosResult.fold(
        (left) {
          emit(TaskManagerStateError(
              (left is NetworkFailure) ? NETWORK_ERROR : SOMETHING_WENT_WRONG));
        },
        (result) async {
          final loggedInResult =
              await getLoggedInUserUsecase(params: NoParams());

          final user = loggedInResult.fold((err) => null, (res) => res);

          if (user == null) {
            emit(const TaskManagerStateError(SOMETHING_WENT_WRONG));
            return;
          }

          emit(TaskManagerStateLoaded(
            todos: result.todos,
            limit: result.limit,
            skip: result.skip,
            total: result.total,
            user: user,
            error: "",
            addedTodo: false,
            addingTodo: false,
          ));
        },
      );
    } catch (e) {
      emit(TaskManagerStateError(e.toString()));
    }
  }

  Future<void> _onAddTodo(
      TaskManagerAddTodo event, Emitter<TaskManagerState> emit) async {
    if (state is TaskManagerStateLoaded) {
      final currentState = state as TaskManagerStateLoaded;
      final isValidTodo = validator.validateTodoText(event.todo);
      if (isValidTodo != null) {
        emit(currentState.copyWith(error: isValidTodo.message));
        return;
      }
      emit(
          currentState.copyWith(error: "", addingTodo: true, addedTodo: false));
      final addTodoResult = await addNewTodoUsecase(
          params: AddNewTodoParams(
              todo: event.todo,
              userid: currentState.user.id,
              isCompleted: false));
      await addTodoResult.fold(
          (left) async => emit(TaskManagerStateError(
              (left is NetworkFailure) ? NETWORK_ERROR : SOMETHING_WENT_WRONG)),
          (result) async {
        final updatedTodos = List<TodoEntity>.from(currentState.todos)
          ..insert(
              0, result.copyWith(id: event.id ?? DateTime.now().millisecond));
        final updatedState = currentState.copyWith(
            todos: updatedTodos,
            total: currentState.total + 1,
            addingTodo: false,
            addedTodo: true);
        _updateLocalTodos(updatedState);
        emit(updatedState);
      });
    }
  }

  Future<void> _updateLocalTodos(
    TaskManagerStateLoaded currentState,
  ) async {
    await saveTodosUseCase(
        params: SaveTodosParams(
            todos: TodoListDTO(
                innerTodos: currentState.todos.map((e) => e.toDTO()).toList(),
                limit: currentState.limit,
                total: currentState.total,
                skip: currentState.skip)));
  }

  Future<void> _onDeleteTodo(
      TaskManagerDeleteTodo event, Emitter<TaskManagerState> emit) async {
    if (state is TaskManagerStateLoaded) {
      final currentState = state as TaskManagerStateLoaded;
      final updatedTodos =
          currentState.todos.where((todo) => todo.id != event.todoId).toList();
      // Save updated todos to local datasource
      final updatedState = currentState.copyWith(
          todos: updatedTodos, total: currentState.total - 1);
      _updateLocalTodos(updatedState);
      emit(updatedState);
    }
  }

  Future<void> _onClearStates(
      TaskManagerClearStates event, Emitter<TaskManagerState> emit) async {
    if (state is TaskManagerStateLoaded) {
      final currentState = state as TaskManagerStateLoaded;
      final updatedState =
          currentState.copyWith(addedTodo: false, addingTodo: false, error: '');
      emit(updatedState);
    }
  }

  Future<void> _onEditTodo(
      TaskManagerEditTodo event, Emitter<TaskManagerState> emit) async {
    if (state is TaskManagerStateLoaded) {
      final currentState = state as TaskManagerStateLoaded;
      final updatedTodos = currentState.todos.map((todo) {
        return todo.id == event.todoId
            ? todo.copyWith(todo: event.todo, completed: event.isCompleted)
            : todo;
      }).toList();
      final updatedState = currentState.copyWith(todos: updatedTodos);
      _updateLocalTodos(updatedState);
      emit(updatedState);
    }
  }

  Future<void> _onLoadMoreTodos(
      TaskManagerGetTodos event, Emitter<TaskManagerState> emit) async {
    if (state is TaskManagerStateLoaded) {
      try {
        final currentState = state as TaskManagerStateLoaded;
        final moreTodos = await getMoreTodosUsecase(
            params: GetAllTodosParams(
          limit: currentState.limit,
          offset: currentState.limit + currentState.skip,
        ));

        await moreTodos.fold(
            (left) async => emit(TaskManagerStateError((left is NetworkFailure)
                ? NETWORK_ERROR
                : SOMETHING_WENT_WRONG)), (result) async {
          final updatedTodos = List<TodoEntity>.from(currentState.todos)
            ..addAll(result.todos);
          final updatedState =
              currentState.copyWith(todos: updatedTodos, skip: result.skip);
          _updateLocalTodos(updatedState);
          emit(updatedState);
        });
      } catch (e) {
        emit(TaskManagerStateError(e.toString()));
      }
    }
  }

// Future<void> _onGetTodoById(
//     TaskManagerGetTodo event, Emitter<TaskManagerState> emit) async {
//   if (state is TaskManagerStateLoaded) {
//     final currentState = state as TaskManagerStateLoaded;
//     try {
//
//       // Update the specific todo in the list
//       final updatedTodos = currentState.todos.firstWhere((t) {
//         return t.id == event.todoId ;
//       });
//
//       emit(currentState.copyWith(todos: updatedTodos));
//     } catch (e) {
//       emit(TaskManagerStateError(e.toString()));
//     }
//   }
// }
}
