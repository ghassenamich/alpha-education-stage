import 'package:education/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:education/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education/core/util/session_storage.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/di/service_locator.dart' as di;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileModel? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final (user, headers) = await SessionStorage.loadSession();
    if (user != null && headers != null) {
      final dataSource = di.sl<ProfileRemoteDataSource>();
      final fetchedProfile = await dataSource.fetchProfile(
        headers: headers,
        userType: user.type,
      );
      setState(() {
        profile = fetchedProfile;
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
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 120.w,
          height: 20.h,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 8.h),
        Container(
          width: 180.w,
          height: 16.h,
          color: Colors.grey.shade300,
        ),
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
      Text(profile!.email,
          style: TextStyle(color: theme.primary, fontSize: 14.sp)),
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
            color: Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  return Column(
    children: [
      _buildInfoTile(Icons.badge, AppLocalizations.of(context)!.userType,
          profile!.status ?? AppLocalizations.of(context)!.unknown, theme),
      _buildInfoTile(Icons.location_city, AppLocalizations.of(context)!.city,
          profile!.city ?? AppLocalizations.of(context)!.na, theme),
      _buildInfoTile(Icons.home, AppLocalizations.of(context)!.address,
          profile!.address ?? AppLocalizations.of(context)!.na, theme),
      _buildInfoTile(Icons.map, AppLocalizations.of(context)!.postalCode,
          profile!.postalCode ?? AppLocalizations.of(context)!.na, theme),
      _buildInfoTile(Icons.phone, AppLocalizations.of(context)!.phonenumber,
          profile!.phone ?? AppLocalizations.of(context)!.na, theme),
      _buildInfoTile(Icons.cake, AppLocalizations.of(context)!.birthdate,
          profile!.birthdate ?? AppLocalizations.of(context)!.na, theme),
    ],
  );
}

Widget _buildDescription(ColorScheme theme) {
  if (isLoading) {
    return Container(
        width: double.infinity, height: 100.h, color: Colors.grey.shade300);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
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
      SizedBox(height: 8.h),
      Text(
        profile!.description ?? AppLocalizations.of(context)!.nodiscription,
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
}
