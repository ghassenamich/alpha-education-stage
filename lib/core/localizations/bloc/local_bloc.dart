import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:education/core/localizations/bloc/local_event.dart';
import 'package:education/core/localizations/bloc/local_state.dart';
import 'package:education/core/localizations/data/locale_repository.dart';
import 'dart:ui' as ui;

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleRepository localeRepository;

  LocaleBloc({required this.localeRepository})
    : super(const LocaleState(Locale('en'))) {
    on<ToggleLocale>((event, emit) async {
      final currentLang = state.locale.languageCode;
      final newLocale = currentLang == 'en'
          ? const Locale('fr')
          : const Locale('en');
      await localeRepository.saveLocaleCode(newLocale.languageCode);
      emit(LocaleState(newLocale));
    });

    on<SetLocale>((event, emit) async {
      await localeRepository.saveLocaleCode(event.locale.languageCode);
      emit(LocaleState(event.locale));
    });

    _loadInitialLocale();
  }

  void _loadInitialLocale() async {
    final savedCode = await localeRepository.getSavedLocaleCode();

    if (savedCode != null && savedCode.isNotEmpty) {
      add(SetLocale(Locale(savedCode)));
    } else {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

      final supportedLanguages = ['en', 'fr'];

      if (supportedLanguages.contains(deviceLocale.languageCode)) {
        add(SetLocale(Locale(deviceLocale.languageCode)));
      } else {
        add(SetLocale(Locale('en')));
      }
    }
  }
}
