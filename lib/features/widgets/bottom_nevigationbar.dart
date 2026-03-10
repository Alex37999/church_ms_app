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
      return BottomNavigationBar(
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        currentIndex: ctrl.index.value,
        onTap: (i) {
          ctrl.changeIndex(i);
          if (onTap != null) onTap!(i);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.brandNavy,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            activeIcon: Icon(Icons.attach_money),
            label: 'Contributions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Receipts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    });
  }
}
