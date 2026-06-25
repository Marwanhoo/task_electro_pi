import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_cubit.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          return ListView(
            children: <Widget>[
              SwitchListTile(
                secondary: Icon(
                  themeCubit.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: const Text('Dark mode'),
                subtitle: Text(
                  themeCubit.isDarkMode ? 'On' : 'Off',
                ),
                value: themeCubit.isDarkMode,
                onChanged: (isEnabled) => themeCubit.toggleThemeMode(),
              ),
            ],
          );
        },
      ),
    );
  }
}
