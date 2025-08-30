import 'package:education/features/auth/domain/entities/user.dart';
import 'package:education/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:education/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  UserProfileModel? profile;
  bool isLoading = true;
  User? user;
  String? translatedDescription;
  bool showOriginal = false;
  String? translatedAddress;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final (storedUser, headers) = await SessionStorage.loadSession();
    user = storedUser;

    final String usert = storedUser!.type;
    final String pathUserType = usert == "schoolagent" ? "school_agent" : usert;

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
      
      _animationController.forward();
    } else {
      setState(() {
        isLoading = false;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: theme.surface,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
            colors: [
              theme.onSurface.withOpacity(0.05),
              theme.primaryContainer.withOpacity(0.08),
              theme.surface,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            _buildModernAppBar(theme),
            
            // Profile Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildProfileContent(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar(ColorScheme theme) {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: theme.onPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: theme.primary.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            AppLocalizations.of(context)!.profile,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        titlePadding: EdgeInsets.only(bottom: 16.h),
      ),
    );
  }

  Widget _buildProfileContent(ColorScheme theme) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildProfileHeader(theme),
          SizedBox(height: 32.h),
          _buildInfoSection(theme),
          SizedBox(height: 32.h),
          _buildDescriptionSection(theme),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme theme) {
    if (isLoading) {
      return _buildLoadingHeader(theme);
    }

    final fullName = "${profile!.firstName} ${profile!.lastName}";

    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withOpacity(0.1),
            theme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primary,
                  theme.secondary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              size: 50.sp,
              color: theme.surface,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            fullName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: theme.onPrimary,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: theme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              profile!.email,
              style: TextStyle(
                color: theme.primary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: theme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: theme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.badge_rounded,
                  size: 18.sp,
                  color: theme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  _getUserTypeLabel(user!.type),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingHeader(ColorScheme theme) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: theme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 150.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: theme.tertiary,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 200.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: theme.tertiary,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ColorScheme theme) {
    if (isLoading) {
      return _buildLoadingInfoSection(theme);
    }

    final infoItems = [
      _InfoItem(
        Icons.location_city_rounded,
        AppLocalizations.of(context)!.city,
        profile!.city ?? AppLocalizations.of(context)!.na,
      ),
      _InfoItem(
        Icons.home_rounded,
        AppLocalizations.of(context)!.address,
        translatedAddress ?? profile!.address ?? AppLocalizations.of(context)!.na,
      ),
      _InfoItem(
        Icons.map_rounded,
        AppLocalizations.of(context)!.postalCode,
        profile!.postalCode ?? AppLocalizations.of(context)!.na,
      ),
      _InfoItem(
        Icons.phone_rounded,
        AppLocalizations.of(context)!.phonenumber,
        profile!.phone ?? AppLocalizations.of(context)!.na,
      ),
      _InfoItem(
        Icons.cake_rounded,
        AppLocalizations.of(context)!.birthdate,
        profile!.birthdate ?? AppLocalizations.of(context)!.na,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primary.withOpacity(0.08),
                  theme.secondary.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primary,
                        theme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: theme.surface,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.onPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          ...infoItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildInfoTile(
              item.icon,
              item.title,
              item.value,
              theme,
              index,
              index == infoItems.length - 1,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLoadingInfoSection(ColorScheme theme) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: theme.tertiary,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
    ColorScheme theme,
    int index,
    bool isLast,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: theme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: theme.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.onSurface.withOpacity(0.7),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ColorScheme theme) {
    if (isLoading) {
      return _buildLoadingDescription(theme);
    }

    final hasTranslation = translatedDescription != null;
    final displayText = showOriginal || !hasTranslation
        ? (profile!.description ?? AppLocalizations.of(context)!.nodiscription)
        : translatedDescription!;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withOpacity(0.05),
            theme.secondary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary,
                          theme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      color: theme.surface,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.onPrimary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              if (hasTranslation)
                IconButton(
                  onPressed: () {
                    setState(() => showOriginal = !showOriginal);
                  },
                  icon: Icon(
                    showOriginal ? Icons.translate : Icons.text_fields,
                    color: theme.primary,
                  ),
                ),
            ],
          ),
          
          if (hasTranslation) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.sp,
                    color: theme.primary.withOpacity(0.7),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      showOriginal
                          ? "Original text"
                          : "Translated via Google Translate. May contain inaccuracies.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.primary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: 20.h),
          Text(
            displayText,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 16.sp,
              height: 1.6,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDescription(ColorScheme theme) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 24.h,
            decoration: BoxDecoration(
              color: theme.tertiary,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              color: theme.tertiary,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
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

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;

  _InfoItem(this.icon, this.title, this.value);
}