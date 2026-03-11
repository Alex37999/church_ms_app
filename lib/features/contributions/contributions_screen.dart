import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../widgets/app_header.dart';
import './controllers/contributions_controller.dart';
import 'contribution_details_screen.dart';
import 'make_donate_screen.dart';

class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ContributionsController>();

    return RefreshIndicator(
      onRefresh: () => ctrl.fetchContributions(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Contributions',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'View your giving \n history and receipts',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.dialog(
                          const MakeDonateScreen(),
                          barrierDismissible: true,
                        );
                      },
                      icon: const Icon(Icons.volunteer_activism, size: 18),
                      label: const Text('Make Donate'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 44, 25),
                        ),
                        foregroundColor: const Color.fromARGB(255, 255, 44, 25),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: [
                      _MetricCard(
                        title: 'Total This Year',
                        value:
                            'KES ${ctrl.totalThisYear.value.toStringAsFixed(0)}',
                        subtitle:
                            '${ctrl.changeThisMonthPercent.value >= 0 ? '+' : ''}${ctrl.changeThisMonthPercent.value.toStringAsFixed(0)}%',
                        iconBg: AppTheme.softGreen,
                        icon: Icons.attach_money,
                        iconColor: AppTheme.success,
                        showTrailing: true,
                      ),
                      const SizedBox(height: 12),
                      _MetricCard(
                        title: 'This Month',
                        value:
                            'KES ${ctrl.totalThisMonth.value.toStringAsFixed(0)}',
                        subtitle:
                            'vs prev ${ctrl.changeThisMonthPercent.value.toStringAsFixed(0)}%',
                        iconBg: AppTheme.softBlue,
                        icon: Icons.calendar_today,
                        iconColor: AppTheme.info,
                        showTrailing: true,
                      ),
                      const SizedBox(height: 12),
                      _MetricCard(
                        title: 'Average',
                        value:
                            'KES ${ctrl.averageAmount.value.toStringAsFixed(0)}',
                        subtitle: 'per contribution',
                        iconBg: AppTheme.softViolet,
                        icon: Icons.pie_chart,
                        iconColor: const Color(0xFF7C3AED),
                        showTrailing: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const SizedBox(height: 8),
                Text(
                  'Track your giving history and download receipts.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _interactiveChip('All'),
                    _interactiveChip('Tithe'),
                    _interactiveChip('Offering'),
                    _interactiveChip('Donation'),
                  ],
                ),
                const SizedBox(height: 18),
                Obx(() {
                  Widget child;
                  if (ctrl.isLoading.value) {
                    child = const Center(child: CircularProgressIndicator());
                  } else if (ctrl.contributions.isEmpty) {
                    child = const Center(
                      child: Text('No contributions available'),
                    );
                  } else {
                    final filtered = _filteredContributions(ctrl);

                    child = Column(
                      key: ValueKey('list-$_selectedFilter-${filtered.length}'),
                      children: filtered.map((contribution) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            color: AppTheme.cardBackground,
                            elevation: 3,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: AppTheme.cardBorder,
                              ),
                            ),
                            shadowColor: Colors.black26,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Get.to(
                                () => ContributionDetailsScreen(
                                  contribution: contribution,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _tagColor(
                                              contribution.type,
                                            ).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            contribution.type,
                                            style: TextStyle(
                                              color: _tagColor(
                                                contribution.type,
                                              ),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 14,
                                              color: AppTheme.textSecondary,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              contribution.date,
                                              style: const TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Receipt: ${contribution.id}',
                                          style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          contribution.status,
                                          style: TextStyle(
                                            color:
                                                contribution.status
                                                        .toLowerCase() ==
                                                    'accepted'
                                                ? AppTheme.success
                                                : (contribution.status
                                                              .toLowerCase() ==
                                                          'pending'
                                                      ? AppTheme.warning
                                                      : AppTheme.textSecondary),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          _formatCurrency(contribution.amount),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          contribution.method,
                                          style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 22,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: child,
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: return a filtered list based on selected filter
  List<ContributionModel> _filteredContributions(ContributionsController ctrl) {
    final list = ctrl.contributions;
    final filter = _selectedFilter.toLowerCase();
    if (filter == 'all') return list;
    return list.where((c) => c.type.toLowerCase() == filter).toList();
  }

  Widget _interactiveChip(String label) {
    final selected = _selectedFilter == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primaryColor : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (_selectedFilter == label) return;
            setState(() {
              _selectedFilter = label;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _tagColor(String type) {
    switch (type.toLowerCase()) {
      case 'tithe':
        return AppTheme.info;
      case 'offering':
        return AppTheme.success;
      case 'building fund':
        return const Color(0xFF8B5CF6);
      default:
        return AppTheme.textSecondary;
    }
  }
}

String _formatCurrency(double value) {
  final s = value.toStringAsFixed(0);
  return 'KES ' +
      s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final bool showTrailing;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 14,
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppTheme.success,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showTrailing)
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.attach_money, color: AppTheme.success),
              ),
          ],
        ),
      ),
    );
  }
}
