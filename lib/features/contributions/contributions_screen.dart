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

    return Obx(
      () => ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Contributions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Track your giving history',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
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
                      child: Material(
                        color: selected
                            ? const Color(0xFFF0F9FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        elevation: selected ? 2 : 0.5,
                        shadowColor: Colors.black.withOpacity(0.04),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(8),
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
                                  ],
                                ),

                                const Spacer(),

                                // Amount and method
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'KES ${contribution.amount.toStringAsFixed(0)}',
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
