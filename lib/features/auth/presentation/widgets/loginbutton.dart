import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.w,
      height: 65.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            Theme.of(context).colorScheme.onPrimaryContainer,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: onPressed,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.surface,
                  strokeWidth: 2.w,
                )
              : Text(
                  label,
                  style: TextStyle(fontFamily: 'roboto',
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
