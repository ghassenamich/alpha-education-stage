import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:education/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/core/util/session_storage.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/di/service_locator.dart' as di;
import 'package:translator_plus/translator_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileModel? profile;
  bool isLoading = true;
  User? user;
  String? translatedDescription;
  bool showOriginal = false;
  String? translatedAddress;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
  final (storedUser, headers) = await SessionStorage.loadSession();
  user = storedUser;

  final String usert = storedUser!.type;
  final String pathUserType = usert == "schoolagent" ? "school_agent" : usert;

  // use pathUserType in your request


    if (user != null && headers != null) {
      final dataSource = di.sl<ProfileRemoteDataSource>();
      final fetchedProfile = await dataSource.fetchProfile(
        headers: headers,
        userType: pathUserType,
      );

      String? translated;
      if (fetchedProfile.description != null &&
          fetchedProfile.description!.isNotEmpty) {
        final currentLang = Localizations.localeOf(context).languageCode;
        if (currentLang != 'fr') {
          final translator = GoogleTranslator();
          try {
            final result = await translator.translate(
              fetchedProfile.description!,
              to: currentLang,
            );
            translated = result.text;
          } catch (_) {
            translated = null;
          }
        }
      }
      if (fetchedProfile.address != null &&
          fetchedProfile.address!.isNotEmpty) {
        final currentLang = Localizations.localeOf(context).languageCode;
        if (currentLang != 'fr') {
          final translator = GoogleTranslator();
          try {
            final result = await translator.translate(
              fetchedProfile.address!,
              to: currentLang,
            );
            translatedAddress = result.text;
          } catch (_) {
            translatedAddress = null;
          }
        }
      }

      setState(() {
        profile = fetchedProfile;
        translatedDescription = translated;
        translatedAddress = translatedAddress;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(fontFamily: "roboto"),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildProfileHeader(theme),
          SizedBox(height: 24.h),
          _buildInfoList(theme),
          Divider(height: 32.h),
          _buildDescription(theme),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme theme) {
    if (isLoading) {
      return Column(
        children: [
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 12.h),
          Container(width: 120.w, height: 20.h, color: Theme.of(context).colorScheme.tertiary),
          SizedBox(height: 8.h),
          Container(width: 180.w, height: 16.h, color: Theme.of(context).colorScheme.tertiary),
        ],
      );
    }

    final fullName = "${profile!.firstName} ${profile!.lastName}";

    return Column(
      children: [
        CircleAvatar(
          radius: 48.r,
          backgroundColor: theme.primary,
          child: Icon(Icons.person, size: 48.r, color: theme.onPrimary),
        ),
        SizedBox(height: 12.h),
        Text(
          fullName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: theme.primary,
            fontFamily: 'roboto',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          profile!.email,
          style: TextStyle(color: theme.primary, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildInfoList(ColorScheme theme) {
    if (isLoading) {
      return Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Container(
              width: double.infinity,
              height: 50.h,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          );
        }),
      );
    }

    return Column(
      children: [
        _buildInfoTile(
          Icons.badge,
          AppLocalizations.of(context)!.userType,
          _getUserTypeLabel(user!.type),
          theme,
        ),

        _buildInfoTile(
          Icons.location_city,
          AppLocalizations.of(context)!.city,
          profile!.city ?? AppLocalizations.of(context)!.na,
          theme,
        ),
        _buildInfoTile(
          Icons.home,
          AppLocalizations.of(context)!.address,
          translatedAddress ??
              profile!.address ??
              AppLocalizations.of(context)!.na,
          theme,
        ),

        _buildInfoTile(
          Icons.map,
          AppLocalizations.of(context)!.postalCode,
          profile!.postalCode ?? AppLocalizations.of(context)!.na,
          theme,
        ),
        _buildInfoTile(
          Icons.phone,
          AppLocalizations.of(context)!.phonenumber,
          profile!.phone ?? AppLocalizations.of(context)!.na,
          theme,
        ),
        _buildInfoTile(
          Icons.cake,
          AppLocalizations.of(context)!.birthdate,
          profile!.birthdate ?? AppLocalizations.of(context)!.na,
          theme,
        ),
      ],
    );
  }

  Widget _buildDescription(ColorScheme theme) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 100.h,
        color: Theme.of(context).colorScheme.tertiary,
      );
    }

    final hasTranslation = translatedDescription != null;
    final displayText = showOriginal || !hasTranslation
        ? (profile!.description ?? AppLocalizations.of(context)!.nodiscription)
        : translatedDescription!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.description,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: theme.primary,
                fontFamily: 'roboto',
              ),
            ),
            if (hasTranslation)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 180.w),
                    child: Text(
                      "Translated via Google Translate. May contain inaccuracies.",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.primary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.right,
                      softWrap: true,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => showOriginal = !showOriginal);
                    },
                    child: Text(
                      showOriginal
                          ? AppLocalizations.of(context)!.seeTranslation
                          : AppLocalizations.of(context)!.seeOriginal,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
          ],
        ),

        SizedBox(height: 8.h),
        Text(
          displayText,
          style: TextStyle(color: theme.primary, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
    ColorScheme theme,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: theme.primary,
          fontFamily: 'roboto',
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: theme.primary,
          fontSize: 16.sp,
          fontFamily: 'roboto',
        ),
      ),
    );
  }

  String _getUserTypeLabel(String type) {
    switch (type) {
      case 'tutor':
        return AppLocalizations.of(context)!.tutor;
      case 'schoolagent':
        return AppLocalizations.of(context)!.schoolAgent;
      case 'parent':
        return AppLocalizations.of(context)!.parent;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }
}
