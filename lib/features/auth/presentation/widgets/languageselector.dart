import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  PopupMenuItem<Locale> _buildMenuItem(BuildContext context, Locale locale, String label) {
    return PopupMenuItem(
      value: locale,
      child: Text(
        label,
        style: TextStyle(fontFamily: 'roboto',color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Icon(
        Icons.language,
        color: Theme.of(context).colorScheme.primary,
      ),
      onSelected: (locale) {
        context.read<LocaleBloc>().add(SetLocale(locale));
      },
      itemBuilder: (context) => [
        _buildMenuItem(context, const Locale('en'), 'English'),
        _buildMenuItem(context, const Locale('fr'), 'Français'),
      ],
      color: Theme.of(context).colorScheme.surface,
    );
  }
}
