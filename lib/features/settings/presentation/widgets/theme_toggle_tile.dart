import 'package:education/config/themes/bloc/theme_bloc.dart';
import 'package:education/config/themes/bloc/theme_event.dart';
import 'package:education/config/themes/bloc/theme_state.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:education/config/themes/widget/theme_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkMode = state.themeMode == ThemeMode.dark;
        final icon = isDarkMode ? Icons.toggle_on : Icons.toggle_off;

        return ListTile(
          leading: Icon(
            Icons.dark_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            AppLocalizations.of(context)!.darkMode,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: ThemeToggleButton(
            icon: icon,
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          onTap: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
        );
      },
    );
  }
}
