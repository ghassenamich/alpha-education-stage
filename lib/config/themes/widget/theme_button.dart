import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_event.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  final double size;
  final Color iconColor;
  final IconData? icon;

  const ThemeToggleButton({
    Key? key,
    this.size = 40,
    this.iconColor = const Color.fromARGB(255, 70, 172, 255),
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {

        final IconData iconToShow = icon ?? Icons.nightlight_round;

        return GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
          child: Icon(
            iconToShow,
            color: iconColor,
            size: size*1.5 ,
          ),
        );
      },
    );
  }
}
