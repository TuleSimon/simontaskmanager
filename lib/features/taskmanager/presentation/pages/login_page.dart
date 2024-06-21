import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/auth_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/body_text.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/filled_button.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/textfield/todo_password_text_field.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/widgets/textfield/todo_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernamephoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 55,
              ),
              TodoTextField(
                controller: usernamephoneController,
                hint: "Enter username",
                title: "Enter your username e.g emily",
              ),
              const SizedBox(
                height: 24,
              ),
              TodoPasswordTextField(
                controller: passwordController,
                title: "Password",
                hint: "Enter your password",
              ),
              const SizedBox(
                height: 55,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthStateLoggedIn) {
                    // Navigate to Home Page when authenticated
                    context.go('/home');
                  } else if (state is AuthStateError) {
                    final error = state.error;
                    // Show error message if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return FilledButtonWithIcon(
                    text: "Login",
                    loading: state is AuthStateLoading,
                    onPressed: () {
                      final username = usernamephoneController.text;
                      final password = passwordController.text;

                      context.read<AuthBloc>().add(AuthEventLogin(
                            username: username,
                            password: password,
                          ));
                    },
                  );
                },
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
