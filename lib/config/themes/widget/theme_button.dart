import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_event.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ThemeToggleButton extends StatelessWidget {
  final Color colord;

  const ThemeToggleButton({
    Key? key,
    this.colord = const Color.fromARGB(255, 70, 172, 255), // default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Icon(
              Icons.nightlight_round,
              color: colord,
              size: 22,
            ),
          ),
        );
      },
    );
  }
}
