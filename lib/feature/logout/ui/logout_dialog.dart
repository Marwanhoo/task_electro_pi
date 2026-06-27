import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/logout/viewmodel/logout_cubit.dart';
import 'package:task_electro_pi/feature/logout/viewmodel/logout_state.dart';

void showLogoutDialog(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  showAdaptiveDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider(
        create: (_) => getIt<LogoutCubit>(),
        child: BlocListener<LogoutCubit, LogoutStates>(
          listener: (blocContext, state) {
            if (state is LogoutSuccessState) {
              Navigator.of(dialogContext).pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            }
          },
          child: Builder(
            builder: (blocContext) {
              final isLoading =
                  blocContext.watch<LogoutCubit>().state is LogoutLoadingState;

              return AlertDialog.adaptive(
                title: const Text('Log out'),
                content: const Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  adaptiveDialogAction(
                    context: dialogContext,
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  adaptiveDialogAction(
                    context: dialogContext,
                    onPressed: isLoading
                        ? null
                        : () => blocContext.read<LogoutCubit>().logout(),
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Log out'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

Widget adaptiveDialogAction({
  required BuildContext context,
  required VoidCallback? onPressed,
  required Widget child,
}) {
  final ThemeData theme = Theme.of(context);
  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return TextButton(onPressed: onPressed, child: child);
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoDialogAction(onPressed: onPressed, child: child);
  }
}
