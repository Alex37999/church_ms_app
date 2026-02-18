import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import './controllers/contributions_controller.dart';

class ContributionsScreen extends GetView<ContributionsController> {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Contributions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: KES ${controller.totalContributions.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else if (controller.contributions.isEmpty)
                  const Center(child: Text('No contributions available'))
                else
                  ...controller.contributions.map((contribution) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
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
                            backgroundColor: Colors.green.shade50,
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.green.shade600,
                            ),
                          ),
                          title: Text(contribution.type),
                          subtitle: Text(contribution.date),
                          trailing: Text(
                            'KES ${contribution.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
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
}
