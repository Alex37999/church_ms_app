import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes/app_pages.dart';
import '../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsController;
  late final Animation<double> _dot1Scale;
  late final Animation<double> _dot2Scale;
  late final Animation<double> _dot3Scale;

  @override
  void initState() {
    super.initState();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dot1Scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _dot2Scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _dot3Scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    Future<void>.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      try {
        final storage = Get.isRegistered<StorageService>()
            ? Get.find<StorageService>()
            : null;

        final loggedIn = storage != null ? await storage.isLoggedIn() : false;
        final token = storage != null ? await storage.getToken() : null;

        if (loggedIn && token != null && token.isNotEmpty) {
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
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF0F2A4A);
    const accentGreen = Color(0xFF16A34A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // subtle large circles in background
            Positioned(
              right: -80,
              top: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              left: -90,
              bottom: -90,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Icon container
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.04),
                          blurRadius: 2,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Brand title with two colors (Poppins)
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Church',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Smartly',
                          style: TextStyle(color: accentGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'CHURCH MANAGEMENT MADE SIMPLE',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 26),

                  // Page indicators (animated)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ScaleTransition(
                        scale: _dot1Scale,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ScaleTransition(
                        scale: _dot2Scale,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: accentGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ScaleTransition(
                        scale: _dot3Scale,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
