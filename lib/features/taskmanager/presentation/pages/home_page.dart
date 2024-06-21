import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/auth_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/task_manager_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/app_colors.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/body_text.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/filled_button.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/textfield/todo_text_field.dart';
import 'package:simontaskmanager/features/taskmanager/utils/extensions/ExtensionsFunc.dart';
import 'package:simontaskmanager/injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _todosListController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      context.read<TaskManagerBloc>().add(TaskManagerInitial());
    });

    _todosListController.addListener(scrollListener);
  }

  void scrollListener() {
    if (_todosListController.offset >=
            _todosListController.position.maxScrollExtent * 1 &&
        !_todosListController.position.outOfRange) {
      debugPrint("Reached End of list");
      context.read<TaskManagerBloc>().add(TaskManagerGetTodos());
    }
  }

  @override
  void dispose() {
    _todosListController.removeListener(scrollListener);
    _todosListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskManagerBloc, TaskManagerState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: BodyText(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              text: (state is TaskManagerStateLoaded)
                  ? "${state.user.firstName} ${state.user.lastName} "
                  : ''),
          leading: (state is TaskManagerStateLoaded)
              ? Padding(
                  padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(state.user.image),
                  ),
                )
              : const CircleAvatar(),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthStateLoggedOut) {
                  context.go(LOGIN_ROUTE);
                }
                return IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEventLogout());
                    },
                    icon: const Icon(Icons.login_outlined));
              },
            )
          ],
        ),
        body: Builder(
          builder: (context) {
            if (state is TaskManagerStateLoading ||
                state is TaskManagerStateInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskManagerStateLoaded) {
              if (state.todos.isEmpty) {
                return const Center(child: Text('No todos available'));
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                    child: BodyText(
                      text: "TODOS",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _todosListController,
                      itemCount: state.todos.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return Dismissible(
                          key: Key(todo.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            context
                                .read<TaskManagerBloc>()
                                .add(TaskManagerDeleteTodo(todoId: todo.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${todo.todo} deleted')),
                            );
                          },
                          child: ListTile(
                            onTap: () {
                              _showAddTodoBottomSheet(context, todo: todo);
                            },
                            leading: Checkbox(
                              checkColor: AppColors.onPrimary,
                              activeColor: AppColors.black,
                              value: todo.completed,
                              onChanged: (value) {
                                context.read<TaskManagerBloc>().add(
                                    TaskManagerEditTodo(
                                        todo: todo.todo,
                                        isCompleted: value ?? todo.completed,
                                        todoId: todo.id));
                              },
                            ),
                            title: Text(todo.todo),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is TaskManagerStateError) {
              return Center(
                  child: Text('Failed to load todos: ${state.message}'));
            } else {
              return const Center(child: Text('No todos available'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: AppColors.black,
          onPressed: () {
            _showAddTodoBottomSheet(context);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.onPrimary,
          ),
        ),
      );
    });
  }

  void _showAddTodoBottomSheet(BuildContext context, {TodoEntity? todo}) {
    final TextEditingController todoController =
        TextEditingController(text: todo?.todo);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<TaskManagerBloc, TaskManagerState>(
          builder: (context, state) {
            if (state is TaskManagerStateLoaded) {
              if (state.addedTodo) {
                context
                    .read<TaskManagerBloc>()
                    .add(const TaskManagerClearStates());
                if(context.canPop()) {
                  Navigator.of(context).pop();
                }
              }
            }
            return Padding(
              padding: EdgeInsets.only(
                  left: HORIZONTAL_PADDING,
                  right: HORIZONTAL_PADDING,
                  top: 50,
                  bottom: 20.0 + context.getKeyboardInsets()),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TodoTextField(
                      controller: todoController,
                      hint: todo != null ? 'Edit Todo' : 'New Todo',
                      title: todo != null ? 'Edit Todo' : 'New Todo',
                    ),
                    const SizedBox(height: 16),
                    FilledButtonWithIcon(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        loading: todo == null
                            ? state is TaskManagerStateLoaded
                                ? state.addingTodo
                                : false
                            : false,
                        onPressed: () {
                          if (todo == null) {
                            final todoText = todoController.text;
                            context
                                .read<TaskManagerBloc>()
                                .add(TaskManagerAddTodo(
                                  todo: todoText,
                                ));
                          } else {
                            context.read<TaskManagerBloc>().add(
                                TaskManagerEditTodo(
                                    todo: todoController.text,
                                    isCompleted: todo.completed,
                                    todoId: todo.id));
                            Navigator.pop(context);
                          }
                        },
                        text: todo != null ? 'Update Todo' : 'Add Todo'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
