import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../widgets/app_header.dart';
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
import './controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _homeController;
  late final BottomNavController _navCtrl;

  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();
    _navCtrl = Get.isRegistered<BottomNavController>()
        ? Get.find<BottomNavController>()
        : Get.put(BottomNavController());
  }

  Widget _buildActivePage(int index) {
    switch (index) {
      case 0:
        return _DashboardTab(
          homeController: _homeController,
          navCtrl: _navCtrl,
        );
      case 1:
        return const ContributionsScreen();
      case 2:
        return const ReceiptsScreen();
      case 3:
        return const EventScreen();
      case 4:
        return const AnnouncementsScreen();
      case 5:
        return const ProfileScreen();
      default:
        return _DashboardTab(
          homeController: _homeController,
          navCtrl: _navCtrl,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final idx = _navCtrl.index.value;

      return Scaffold(
        backgroundColor: const Color(0xFFFBFCFF),
        body: KeyedSubtree(key: ValueKey(idx), child: _buildActivePage(idx)),
        bottomNavigationBar: AppBottomNavigationBar(
          onTap: (i) {
            // Trigger refresh for the tapped tab so data updates immediately.
            // Home
            if (i == 0) {
              _homeController.fetchDashboard();
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

class _DashboardTab extends StatelessWidget {
  final HomeController homeController;
  final BottomNavController navCtrl;

  const _DashboardTab({required this.homeController, required this.navCtrl});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: homeController.fetchDashboard,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() {
            final hp = homeController.homepage.value?.data;
            final isLoading = homeController.isLoading.value;

            if (isLoading) {
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          value: '${hp?.upcomingEventsCount ?? 0} Events',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Recent Activity',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View all >',
                          style: TextStyle(color: Color(0xFF4B5563)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: (hp?.recentActivity ?? []).map<Widget>((act) {
                      final icon = act.type == 'announcement'
                          ? Icons.campaign_outlined
                          : Icons.attach_money;
                      final subtitle = act.description ?? '';
                      final time = act.time != null
                          ? _formatRelative(act.time!)
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
                          surfaceTintColor: Colors.white,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xFFE7ECF3)),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFF1F5F9),
                              child: Icon(icon, color: const Color(0xFF334155)),
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
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            );
          }),
        ],
      ),
    );
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
      elevation: 5,
      shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE7ECF3)),
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
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
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
