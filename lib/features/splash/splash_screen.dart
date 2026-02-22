import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:churchmsapp/app/theme/app_theme.dart';
import '../../app/routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // Always send users to the login screen after splash
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryDark = Color.lerp(AppTheme.primaryColor, Colors.black, 0.18)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _LogoMark(colorScheme: colorScheme, primary: primaryDark),
                    const SizedBox(height: 20),
                    Text(
                      'ChurchMS',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Learn smarter, not harder',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // const Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: EdgeInsets.only(bottom: 28),
              //     child: _PageIndicator(activeIndex: 1, count: 3),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.colorScheme, required this.primary});

  final ColorScheme colorScheme;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Icon(
                Icons.menu_book_rounded,
                size: 46,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: Color(0xFFFFC107).withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
