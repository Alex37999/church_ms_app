import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nevigationbar.dart';
import '../widgets/app_header.dart';
import '../widgets/drawer.dart';
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
import '../../app/theme/app_theme.dart';
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
        // extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(),
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
                AppHeader(),
                const SizedBox(height: 18),
                YearToDateCard(data: hp),
                const SizedBox(height: 12),
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
                        color: AppTheme.softGreen,
                        icon: Icons.attach_money,
                        iconColor: Colors.teal,
                        title: 'Total Given',
                        valueWidget: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${hp?.currencySymbol ?? 'KSh'} ',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.brandNavy,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: formatNumber(hp?.totalContributions),
                                style: GoogleFonts.poppins(
                                  color: AppTheme.brandNavy,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _SummaryCard(
                        color: AppTheme.softBlue,
                        icon: Icons.trending_up,
                        iconColor: AppTheme.info,
                        title: 'Last Giving',
                        value: hp?.lastContributionDate ?? '-',
                      ),
                      _SummaryCard(
                        color: AppTheme.softViolet,
                        icon: Icons.location_on,
                        iconColor: const Color(0xFF7C3AED),
                        title: 'My Branch',
                        value: hp?.branchName ?? '-',
                      ),
                      InkWell(
                        onTap: () => navCtrl.changeIndex(3),
                        borderRadius: BorderRadius.circular(12),
                        child: _SummaryCard(
                          color: AppTheme.softOrange,
                          icon: Icons.event,
                          iconColor: AppTheme.warning,
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
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text(
                      //     'View all >',
                      //     style: TextStyle(color: AppTheme.textSecondary),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: (hp?.recentActivity ?? []).map<Widget>((act) {
                      final subtitle = act.description ?? '';
                      final time = act.time != null
                          ? _formatRelative(act.time!)
                          : '';

                      IconData iconData;
                      Color iconColor;
                      if (act.type == 'announcement') {
                        iconData = Icons.campaign_outlined;
                        iconColor = Colors.amber; // yellow for announcements
                      } else if (act.type == 'event') {
                        iconData = Icons.event;
                        iconColor = AppTheme.warning; // event color
                      } else {
                        iconData = Icons.attach_money;
                        iconColor = Colors.teal; // contributions color
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: AppTheme.cardBackground,
                          elevation: 5,
                          shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
                          surfaceTintColor: AppTheme.cardBackground,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: AppTheme.cardBorder),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withOpacity(0.12),
                              child: Icon(iconData, color: iconColor),
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
                                color: AppTheme.textSecondary,
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
  final String? value;
  final Widget? valueWidget;

  const _SummaryCard({
    this.color,
    required this.icon,
    this.iconColor,
    required this.title,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppTheme.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.12,
    );
    final valueStyle = GoogleFonts.poppins(
      color: AppTheme.brandNavy,
      fontSize: 15,
      fontWeight: FontWeight.w900,
      height: 1.05,
    );

    return Card(
      color: AppTheme.cardBackground,
      elevation: 5,
      shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
      surfaceTintColor: AppTheme.cardBackground,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: color ?? AppTheme.surfaceSubtle,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: iconColor ?? AppTheme.textSecondary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 8),
            valueWidget ??
                Text(
                  value ?? '-',
                  textAlign: TextAlign.center,
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

/// A prominent card showing year-to-date giving, goal and progress.
class YearToDateCard extends StatelessWidget {
  final dynamic data;

  const YearToDateCard({this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = (data?.totalContributions ?? 0) as int;
    final symbol = data?.currencySymbol ?? 'KSh';

    // Keep a simple visual: show full bar when there is any total, empty otherwise.
    double visualValue = total > 0 ? 1.0 : 0.0;

    final titleStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.white70, letterSpacing: 1.2);
    final amountStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w800,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: AppTheme.headerBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: AppTheme.headerBackground,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('YEAR TO DATE GIVING', style: titleStyle),
                        const SizedBox(height: 8),
                        Text(
                          '$symbol ${formatNumber(total)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 28, // Adjust font size as needed
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.softGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_upward,
                      color: AppTheme.accentGreen,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Open Contributions to view donations.',
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: visualValue,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(AppTheme.accentGreen),
                ),
              ),
            ],
          ),
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

String formatNumber(int? n) {
  if (n == null) return '0';
  final s = n.toString();
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return s.replaceAllMapped(reg, (match) => ',');
}
