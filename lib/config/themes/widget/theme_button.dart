import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_event.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              ),
            child: Icon(
              Icons.nightlight_round,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
        );
      },
    );
  }
}
