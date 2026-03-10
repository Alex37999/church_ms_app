import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../contributions/contributions_screen.dart';
import '../receipts/receipts_screen.dart';
import '../event/event_screen.dart';
import '../announcements/announcements_screen.dart';
import '../profile/profile_screen.dart';
import '../contributions/controllers/contributions_controller.dart';
import '../receipts/controllers/receipts_controller.dart';
import '../event/controller/event_controller.dart';
import '../announcements/controllers/announcements_controller.dart';
import '../profile/controllers/profile_controller.dart';
import '../notification/controllers/notification_controller.dart';
import './controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(BottomNavController());

    return Obx(() {
      final idx = navCtrl.index.value;

      final pages = <Widget>[
        // Dashboard tab (redesigned)
        Column(
          children: [
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: controller.fetchDashboard,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Obx(() {
                        final hp = controller.homepage.value?.data;
                        final isLoading = controller.isLoading.value;

                        if (isLoading) {
                          return const SizedBox(
                            height: 240,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return Column(
                          children: [
                            // Top header with rounded bottom and content
                            SafeArea(
                              top: true,
                              bottom: false,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 260,
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  76,
                                  16,
                                  12,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B2A53),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(32),
                                    bottomRight: Radius.circular(32),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // logo + app name
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              'assets/icon/app_icon.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'CHURCH SMARTLY',
                                                style: TextStyle(
                                                  color: Color(0xFF98C6FF),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                hp?.churchName ??
                                                    'Grace Community Church',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // notifications (functional)
                                        IconButton(
                                          onPressed: () async {
                                            // If NotificationController is registered, refresh first
                                            if (Get.isRegistered<
                                              NotificationController
                                            >()) {
                                              Get.find<NotificationController>()
                                                  .fetchNotifications();
                                            }

                                            // Navigate to notifications screen (binding will register controller if needed)
                                            await Get.toNamed('/notifications');
                                          },
                                          icon: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              const Icon(
                                                Icons.notifications_none,
                                                color: Colors.white,
                                              ),
                                              if ((hp?.unreadNotifications ??
                                                      0) >
                                                  0)
                                                Positioned(
                                                  right: -2,
                                                  top: -6,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF10B981,
                                                      ),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFF0B2A53,
                                                        ),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      (hp?.unreadNotifications ??
                                                              0)
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    const Text(
                                      'Welcome back',
                                      style: TextStyle(
                                        color: Color(0xFFBFD8FF),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Member No: ${hp?.memberNumber ?? 'GCC-XXXX'}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      hp?.branchName ?? 'Branch',
                                      style: const TextStyle(
                                        color: Color(0xFFBFD8FF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // 2x2 white summary cards
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.28,
                                children: [
                                  _SummaryCard(
                                    color: const Color(0xFFEFFAF3),
                                    icon: Icons.attach_money,
                                    iconColor: const Color(0xFF16A34A),
                                    title: 'Total Given',
                                    value:
                                        '${hp?.currencySymbol ?? 'KES'} ${hp?.totalContributions ?? '0'}',
                                  ),
                                  _SummaryCard(
                                    color: const Color(0xFFEFF6FF),
                                    icon: Icons.trending_up,
                                    iconColor: const Color(0xFF2563EB),
                                    title: 'Last Giving',
                                    value: hp?.lastContributionDate ?? '-',
                                  ),
                                  _SummaryCard(
                                    color: const Color(0xFFF5F3FF),
                                    icon: Icons.location_on,
                                    iconColor: const Color(0xFF7C3AED),
                                    title: 'My Branch',
                                    value: hp?.branchName ?? '-',
                                  ),
                                  InkWell(
                                    onTap: () => navCtrl.changeIndex(3),
                                    borderRadius: BorderRadius.circular(12),
                                    child: _SummaryCard(
                                      color: const Color(0xFFFFF7ED),
                                      icon: Icons.event,
                                      iconColor: const Color(0xFFF97316),
                                      title: 'Upcoming',
                                      value:
                                          '${hp?.upcomingEventsCount ?? 0} Events',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Recent activity header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Recent Activity',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'View all >',
                                      style: TextStyle(
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Recent activity list
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                children: (hp?.recentActivity ?? [])
                                    .map<Widget>((act) {
                                      final icon = act.type == 'announcement'
                                          ? Icons.campaign_outlined
                                          : Icons.attach_money;
                                      final subtitle = act.description ?? '';
                                      final time = act.time != null
                                          ? _formatRelative(act.time!)
                                          : '';

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                        ),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 6,
                                          shadowColor: const Color.fromRGBO(
                                            0,
                                            0,
                                            0,
                                            0.06,
                                          ),
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: BorderSide(
                                              color: Colors.grey.shade100,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: const Color(
                                                0xFFF3F4F6,
                                              ),
                                              child: Icon(
                                                icon,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            title: Text(
                                              act.title ?? '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(subtitle),
                                            trailing: Text(
                                              time,
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),

                            const SizedBox(height: 80),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        ContributionsScreen(),
        const ReceiptsScreen(),
        const EventScreen(),
        const AnnouncementsScreen(),
        const ProfileScreen(),
      ];

      return Scaffold(
        backgroundColor: const Color(0xFFFBFCFF),
        body: IndexedStack(index: idx, children: pages),
        bottomNavigationBar: AppBottomNavigationBar(
          onTap: (i) {
            // Trigger refresh for the tapped tab so data updates immediately.
            // Home
            if (i == 0) {
              controller.fetchDashboard();
            }

            // Contributions
            if (i == 1) {
              if (Get.isRegistered<ContributionsController>()) {
                Get.find<ContributionsController>().fetchContributions();
              }
            }

            // Receipts
            if (i == 2) {
              if (Get.isRegistered<ReceiptsController>()) {
                Get.find<ReceiptsController>().fetchReceipts();
              }
            }

            // Events
            if (i == 3) {
              if (Get.isRegistered<EventController>()) {
                Get.find<EventController>().fetchEvents();
              }
            }

            // Announcements
            if (i == 4) {
              if (Get.isRegistered<AnnouncementsController>()) {
                Get.find<AnnouncementsController>().fetchAnnouncements();
              }
            }

            // Profile
            if (i == 5) {
              if (Get.isRegistered<ProfileController>()) {
                Get.find<ProfileController>().fetchProfile();
              }
            }
          },
        ),
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
