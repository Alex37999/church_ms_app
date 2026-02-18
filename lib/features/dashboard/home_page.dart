import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../widgets/app_header.dart';
import '../contributions/contributions_screen.dart';
import '../receipts/receipts_screen.dart';
import '../announcements/announcements_screen.dart';
import '../profile/profile_screen.dart';
import './controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(BottomNavController());

    return Obx(() {
      final idx = navCtrl.index.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final scale = (width / 420).clamp(0.85, 1.25);
          final horizontalPadding = width < 420 ? 12.0 : 16.0;
          final gridCount = width >= 1000
              ? 4
              : width >= 700
              ? 3
              : width >= 420
              ? 2
              : 1;
          final childAspect = gridCount == 1 ? 3.2 : 1.6;

          // Build header widget
          final header = AppHeader(
            scale: scale,
            horizontalPadding: horizontalPadding,
          );

          final pages = <Widget>[
            // Dashboard
            ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                12,
              ),
              children: [
                header,
                const SizedBox(height: 16),
                Text(
                  'Welcome back, David!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        (Theme.of(context).textTheme.headlineSmall?.fontSize ??
                            18) *
                        scale,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Member No: GCC-1024',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: gridCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspect,
                  children: [
                    _SummaryCard(
                      color: Colors.green.shade50,
                      icon: Icons.savings_outlined,
                      title: 'My Total Contributions',
                      value: 'KES 85,000',
                    ),
                    _SummaryCard(
                      color: Colors.blue.shade50,
                      icon: Icons.show_chart,
                      title: 'Last Contribution',
                      value: 'KES 10,000',
                    ),
                    _SummaryCard(
                      color: Colors.purple.shade50,
                      icon: Icons.location_on_outlined,
                      title: 'My Branch',
                      value: 'Westside Branch',
                    ),
                    _SummaryCard(
                      color: Colors.orange.shade50,
                      icon: Icons.event_available_outlined,
                      title: 'Upcoming Events',
                      value: '3 Events',
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize:
                        (Theme.of(context).textTheme.titleMedium?.fontSize ??
                            16) *
                        scale,
                  ),
                ),
                const SizedBox(height: 12),

                _ActivityItem(
                  icon: Icons.monetization_on_outlined,
                  title: 'Contribution',
                  subtitle: 'Tithe - KES 10,000',
                  time: '2 days ago',
                ),
                const SizedBox(height: 8),
                _ActivityItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Receipt',
                  subtitle: 'January Receipt Ready',
                  time: '3 days ago',
                ),
                const SizedBox(height: 8),
                _ActivityItem(
                  icon: Icons.campaign_outlined,
                  title: 'Announcement',
                  subtitle: 'Sunday Service Update',
                  time: '1 week ago',
                ),
                const SizedBox(height: 80),
              ],
            ),

            const ContributionsScreen(),
            const ReceiptsScreen(),
            const AnnouncementsScreen(),
            const ProfileScreen(),
          ];

          return Scaffold(
            backgroundColor: const Color(0xFFFBFCFF),
            body: IndexedStack(index: idx, children: pages),
            bottomNavigationBar: AppBottomNavigationBar(onTap: (i) {}),
          );
        },
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color ?? Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(icon, color: Colors.black54),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ),
    );
  }
}
