import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<ToggleTheme>((event, emit) {
      final newMode = state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(ThemeState(newMode));
    });

    on<SetTheme>((event, emit) => emit(ThemeState(event.themeMode)));
  }
}
