import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/app_controller.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../contributions/contributions_screen.dart';
import '../receipts/receipts_screen.dart';
import '../announcements/announcements_screen.dart';
import '../profile/profile_screen.dart';
import '../contributions/contribution_add.dart';
import '../receipts/receipt_add.dart';
import '../announcements/announcement_add.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppController>();
    final navCtrl = Get.put(BottomNavController());

    final pages = <Widget>[
      // Home dashboard (simple welcome)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Environment: ${appCtrl.env}'),
            const SizedBox(height: 20),
            // Placeholder cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                4,
                (i) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 56) / 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined),
                          const SizedBox(height: 8),
                          Text(
                            'Title $i',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          const Text('Subtitle'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const ContributionsScreen(),
      const ReceiptsScreen(),
      const AnnouncementsScreen(),
      const ProfileScreen(),
    ];

    return Obx(() {
      final idx = navCtrl.index.value;
      return Scaffold(
        appBar: AppBar(title: Text('ChurchMS (${appCtrl.env})')),
        body: IndexedStack(index: idx, children: pages),
        bottomNavigationBar: AppBottomNavigationBar(onTap: (i) {}),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to add/create pages depending on current tab
            switch (idx) {
              case 1:
                Get.to(() => const ContributionAddPage());
                break;
              case 2:
                Get.to(() => const ReceiptAddPage());
                break;
              case 3:
                Get.to(() => const AnnouncementAddPage());
                break;
              default:
                Get.snackbar('Action', 'No create action for this tab');
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
