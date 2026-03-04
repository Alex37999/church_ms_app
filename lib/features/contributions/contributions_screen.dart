import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/contributions_controller.dart';
import 'contribution_details_screen.dart';

class ContributionsScreen extends GetView<ContributionsController> {
  ContributionsScreen({super.key});

  // Reactive UI state
  final RxString _selectedFilter = 'All'.obs;
  final RxnString _selectedContributionId = RxnString();

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;

    return Obx(() {
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
                  // Header row with donate button
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
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      OutlinedButton.icon(
                        onPressed: () {
                          Get.snackbar('Donate', 'Make Donate pressed');
                        },
                        icon: const Icon(Icons.volunteer_activism, size: 18),
                        label: const Text('Make Donate'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE11D48)),
                          foregroundColor: const Color(0xFFE11D48),
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

                  // Metric cards stacked vertically
                  _MetricCard(
                    title: 'Total This Year',
                    value: 'KES ${ctrl.totalThisYear.value.toStringAsFixed(0)}',
                    subtitle:
                        '${ctrl.changeThisMonthPercent.value >= 0 ? '+' : ''}${ctrl.changeThisMonthPercent.value.toStringAsFixed(0)}%',
                    iconBg: const Color(0xFFEFFAF3),
                    icon: Icons.attach_money,
                    iconColor: const Color(0xFF16A34A),
                    showTrailing: true,
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    title: 'This Month',
                    value:
                        'KES ${ctrl.totalThisMonth.value.toStringAsFixed(0)}',
                    subtitle:
                        'vs prev ${ctrl.changeThisMonthPercent.value.toStringAsFixed(0)}%',
                    iconBg: const Color(0xFFEFF6FF),
                    icon: Icons.calendar_today,
                    iconColor: const Color(0xFF2563EB),
                    showTrailing: true,
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    title: 'Average',
                    value: 'KES ${ctrl.averageAmount.value.toStringAsFixed(0)}',
                    subtitle: 'per contribution',
                    iconBg: const Color(0xFFF5F3FF),
                    icon: Icons.pie_chart,
                    iconColor: const Color(0xFF7C3AED),
                    showTrailing: true,
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

                  // Receipts list
                  Obx(() {
                    if (ctrl.receipts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receipts',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ...ctrl.receipts.map((r) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(r.receiptNumber),
                              subtitle: Text(
                                '${r.date} • ${_formatCurrency(r.amount)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.download_outlined),
                                onPressed: () => ctrl.copyReceiptUrlToClipboard(
                                  r.downloadUrl,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 14),

                  // Filter chips
                  Obx(
                    () => Row(
                      children: [
                        _interactiveChip('All'),
                        const SizedBox(width: 8),
                        _interactiveChip('Tithe'),
                        const SizedBox(width: 8),
                        _interactiveChip('Offering'),
                        const SizedBox(width: 8),
                        _interactiveChip('Donation'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (ctrl.isLoading.value)
                    const Center(child: CircularProgressIndicator())
                  else if (ctrl.contributions.isEmpty)
                    const Center(child: Text('No contributions available'))
                  else
                    ..._filteredContributions(ctrl).map((contribution) {
                      final id = _contributionId(contribution);
                      final selected = _selectedContributionId.value == id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          color: Colors.white,
                          elevation: selected ? 8 : 3,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade100),
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
                                  // Left tag and date
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
                                            color: _tagColor(contribution.type),
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
                                            color: Colors.black45,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            contribution.date,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Receipt: ${contribution.id}',
                                        style: const TextStyle(
                                          color: Colors.black45,
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
                                              ? Colors.green
                                              : (contribution.status
                                                            .toLowerCase() ==
                                                        'pending'
                                                    ? Colors.orange
                                                    : Colors.black54),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  // Amount and method
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 8),

                                  const Icon(
                                    Icons.chevron_right,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper: return a filtered list based on selected filter
  List<ContributionModel> _filteredContributions(ContributionsController ctrl) {
    final list = ctrl.contributions;
    final filter = _selectedFilter.value.toLowerCase();
    if (filter == 'all') return list;
    return list.where((c) => c.type.toLowerCase() == filter).toList();
  }

  // Helper: derive a stable id for a contribution
  String _contributionId(dynamic c) {
    try {
      return c.id as String;
    } catch (_) {
      return c.hashCode.toString();
    }
  }

  Widget _interactiveChip(String label) {
    final selected = _selectedFilter.value == label;
    return GestureDetector(
      onTap: () => _selectedFilter.value = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3B82F6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _tagColor(String type) {
    switch (type.toLowerCase()) {
      case 'tithe':
        return const Color(0xFF3B82F6);
      case 'offering':
        return const Color(0xFF10B981);
      case 'building fund':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.green,
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.attach_money, color: Color(0xFF10B981)),
              ),
          ],
        ),
      ),
    );
  }
}
