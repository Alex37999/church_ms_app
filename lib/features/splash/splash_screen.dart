import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:churchmsapp/app/theme/app_theme.dart';
import '../../app/routes/app_pages.dart';
import '../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      // If a logged-in session exists, go to home; otherwise go to login
      try {
        final loggedIn = Get.isRegistered<StorageService>()
            ? await Get.find<StorageService>().isLoggedIn()
            : false;
        if (loggedIn) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      } catch (_) {
        Get.offAllNamed(Routes.LOGIN);
      }
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
                      'Seamless Community. Inspired Faith.',
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
      width: 100,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 60,
                  height: 60,
                  //color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
