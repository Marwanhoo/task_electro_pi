import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/login_cubit.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (listenerContext, state) {
        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(listenerContext).showSnackBar(
            SnackBar(content: Text('Welcome, ${state.session.username}')),
          );
          listenerContext.go('/');
        } else if (state is LoginFailureState) {
          ScaffoldMessenger.of(listenerContext).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (builderContext, state) {
        final cubit = builderContext.read<LoginCubit>();
        final isLoading = state is LoginLoadingState;

        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Sign in with your TMDB account',
                  style: Theme.of(builderContext).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: cubit.usernameController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cubit.passwordController,
                  enabled: !isLoading,
                  obscureText: cubit.obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: isLoading ? null : cubit.toggleObscurePassword,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) {
                      cubit.login();
                    }
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isLoading ? null : cubit.login,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
