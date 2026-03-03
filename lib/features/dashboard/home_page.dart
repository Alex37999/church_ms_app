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

      final pages = <Widget>[
        // Dashboard tab
        Column(
          children: [
            const AppHeader(horizontalPadding: 16),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Obx(() {
                        final hp = controller.homepage.value?.data;
                        final isLoading = controller.isLoading.value;

                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Member No: ${hp?.memberNumber ?? 'N/A'}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 12),

                            // 2x2 grid like the screenshot
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.40,
                              children: [
                                _SummaryCard(
                                  color: const Color(0xFFEFFAF3),
                                  icon: Icons.attach_money,
                                  iconColor: const Color(0xFF16A34A),
                                  title: 'My Total Contributions',
                                  value:
                                      '${hp?.currencySymbol ?? 'KSh'} ${hp?.totalContributions?.toString() ?? '0'}',
                                ),
                                _SummaryCard(
                                  color: const Color(0xFFEFF6FF),
                                  icon: Icons.show_chart,
                                  iconColor: const Color(0xFF2563EB),
                                  title: 'Last Contribution',
                                  value: hp?.lastContributionDate ?? 'N/A',
                                ),
                                _SummaryCard(
                                  color: const Color(0xFFF5F3FF),
                                  icon: Icons.location_on,
                                  iconColor: const Color(0xFF7C3AED),
                                  title: 'My Branch',
                                  value: hp?.branchName ?? '-',
                                ),
                                _SummaryCard(
                                  color: const Color(0xFFFFF7ED),
                                  icon: Icons.event,
                                  iconColor: const Color(0xFFF97316),
                                  title: 'Upcoming Events',
                                  value:
                                      '${hp?.upcomingEventsCount?.toString() ?? '0'} Events',
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),
                            Text(
                              'Recent Activity',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),

                            if (hp?.recentActivity != null &&
                                hp!.recentActivity!.isNotEmpty)
                              ...hp.recentActivity!.map((act) {
                                final icon = act.type == 'announcement'
                                    ? Icons.campaign_outlined
                                    : Icons.circle;
                                final subtitle = act.description ?? '';
                                final time = act.time != null
                                    ? _formatRelative(act.time!)
                                    : '';
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: _ActivityItem(
                                    icon: icon,
                                    iconBg: const Color(0xFFF3F4F6),
                                    title: act.title ?? '-',
                                    subtitle: subtitle,
                                    time: time,
                                  ),
                                );
                              }).toList()
                            else
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text('No recent activity'),
                              ),

                            const SizedBox(height: 80),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        ContributionsScreen(),
        const ReceiptsScreen(),
        const AnnouncementsScreen(),
        const ProfileScreen(),
      ];

      return Scaffold(
        backgroundColor: const Color(0xFFFBFCFF),
        body: IndexedStack(index: idx, children: pages),
        bottomNavigationBar: AppBottomNavigationBar(onTap: (i) {}),
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String value;

  const _SummaryCard({
    this.color,
    required this.icon,
    this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Colors.black54,
      fontSize: 11,
      height: 1.15,
    );
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 1.1,
    );

    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.06),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color ?? Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(9),
              child: Icon(icon, color: iconColor ?? Colors.black54, size: 20),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color? iconBg;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    this.iconBg,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.06),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBg ?? Colors.grey.shade100,
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

String _formatRelative(DateTime t) {
  final now = DateTime.now();
  final diff = now.difference(t.toLocal());
  if (diff.inDays >= 7) {
    return '${t.toLocal().toString().split(' ')[0]}';
  }
  if (diff.inDays >= 1) return '${diff.inDays} days ago';
  if (diff.inHours >= 1) return '${diff.inHours} hours ago';
  if (diff.inMinutes >= 1) return '${diff.inMinutes} minutes ago';
  return 'just now';
}
