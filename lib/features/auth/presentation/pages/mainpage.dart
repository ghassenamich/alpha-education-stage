import 'package:education/config/themes/widget/theme_button.dart';
import 'package:education/core/localizations/bloc/local_bloc.dart';
import 'package:education/core/localizations/bloc/local_event.dart';
import 'package:education/features/auth/presentation/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 70, 172, 255),
      ),
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 48, 255),

      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.onSurface,
              Theme.of(context).colorScheme.onSurfaceVariant,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 156.h),
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: TextStyle(
                      fontFamily: 'roboto',
                      fontSize: 35.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Image.asset(
                    'assets/images/image.png',
                    width: 200.w,
                    height: 200.h,
                  ),

                  SizedBox(height: 20.h),
                  Text(
                    AppLocalizations.of(context)!.mobileApp,
                    style: TextStyle(
                      fontFamily: 'roboto',
                      fontSize: 35.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.start,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'roboto',
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20.sp,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    width: 200.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.onSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.r),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 24.w,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.getStarted,
                            style: TextStyle(
                              fontFamily: 'roboto',
                              color: Theme.of(context).colorScheme.onError,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 90.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PopupMenuButton<Locale>(
                        icon: Icon(
                          Icons.language,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onSelected: (locale) {
                          context.read<LocaleBloc>().add(SetLocale(locale));
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: const Locale('en'),
                            child: Text(
                              'English',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: const Locale('fr'),
                            child: Text(
                              'Français',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: ThemeToggleButton(size: 16.w,
                          icon: Icons.nightlight_round,
                          iconColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
