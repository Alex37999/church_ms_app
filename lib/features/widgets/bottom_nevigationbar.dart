import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';

class BottomNavController extends GetxController {
  final RxInt index = 0.obs;
  void changeIndex(int i) => index.value = i;
}

/// A reusable bottom navigation bar using GetX for state.
///
/// Usage:
/// - Place `AppBottomNavigationBar(onTap: (i) => ... )` in a `Scaffold.bottomNavigationBar`.
/// - Listen to selected index with `Get.find<BottomNavController>().index` if needed.
class AppBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int>? onTap;

  const AppBottomNavigationBar({this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavController ctrl = Get.isRegistered<BottomNavController>()
        ? Get.find<BottomNavController>()
        : Get.put(BottomNavController(), permanent: false);

    return Obx(() {
      // Custom pill-style bottom nav
      final items = <Map<String, dynamic>>[
        {'icon': Icons.home_outlined, 'label': 'Home'},
        {'icon': Icons.attach_money_outlined, 'label': 'Giving'},
        {'icon': Icons.receipt_long_outlined, 'label': 'Receipts'},
        {'icon': Icons.event_outlined, 'label': 'Events'},
        {'icon': Icons.notifications_none, 'label': 'Updates'},
        {'icon': Icons.person_outline, 'label': 'Profile'},
      ];

      return SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  // translucent pill background; set Scaffold.extendBody=true so
                  // underlying screen content is visible outside the pill when scrolling
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppTheme.cardBorder.withOpacity(0.9),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final it = items[index];
                    final selected = ctrl.index.value == index;
                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          ctrl.changeIndex(index);
                          if (onTap != null) onTap!(index);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.primaryColor.withOpacity(0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                it['icon'] as IconData,
                                size: 20,
                                color: selected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 16,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 160),
                                  style: TextStyle(
                                    fontSize: selected ? 13 : 11,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: selected
                                        ? AppTheme.brandNavy
                                        : AppTheme.textSecondary,
                                  ),
                                  child: Text(
                                    it['label'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ), // Row
              ), // Container
            ), // BackdropFilter
          ), // ClipRRect
        ), // Padding
      ); // SafeArea
    });
  }
}
