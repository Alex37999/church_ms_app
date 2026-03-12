import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'binding/event_binding.dart';
import 'controller/event_controller.dart';

class EventScreen extends GetView<EventController> {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ensure binding is applied when navigating directly
    EventBinding().dependencies();
    final ctrl = Get.find<EventController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: ctrl.fetchEvents,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Church events and activities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (ctrl.isLoading.value)
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (ctrl.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(child: Text(ctrl.errorMessage.value)),
                )
              else if (ctrl.events.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No upcoming events')),
                )
              else
                ...(() {
                  final sortedEvents = [...ctrl.events]
                    ..sort(
                      (a, b) => _eventDateTime(
                        b.date,
                        b.time,
                      ).compareTo(_eventDateTime(a.date, a.time)),
                    );
                  return sortedEvents.map((e) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: const Color.fromRGBO(15, 23, 42, 0.08),
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFFE7ECF3)),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '${e.date} ${e.time}'.trim(),
                                      style: const TextStyle(
                                        color: Color(0xFF1D4ED8),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _EventMetaPill(
                                    icon: Icons.place_rounded,
                                    label: e.venue,
                                  ),
                                  _EventMetaPill(
                                    icon: Icons.group_rounded,
                                    label: '${e.capacity} capacity',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 4),
                              Text(
                                e.description,
                                style: const TextStyle(
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (e.rsvpRequired && !e.isAttending)
                                SizedBox(
                                  width: double.infinity,
                                  child: Obx(() {
                                    final processing = ctrl.isProcessing(e.id);
                                    return ElevatedButton(
                                      onPressed: processing
                                          ? null
                                          : () => ctrl.rsvp(e.id),
                                      child: processing
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text("RSVP - I'm Attending"),
                                    );
                                  }),
                                ),
                              if (e.rsvpRequired && e.isAttending)
                                SizedBox(
                                  width: double.infinity,
                                  child: Obx(() {
                                    final processing = ctrl.isProcessing(e.id);
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: processing
                                          ? null
                                          : () => ctrl.cancelRsvp(e.id),
                                      child: processing
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.red,
                                              ),
                                            )
                                          : const Text('Cancel RSVP'),
                                    );
                                  }),
                                ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: e.isAttending
                                        ? Colors.green[700]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    e.isAttending
                                        ? "You're Attending"
                                        : (e.rsvpRequired
                                              ? 'RSVP Required'
                                              : 'No RSVP needed'),
                                    style: TextStyle(
                                      color: e.isAttending
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList();
                })(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime _eventDateTime(String date, String time) {
  final normalizedTime = time.trim().isEmpty ? '00:00:00' : time.trim();
  final candidates = ['$date $normalizedTime', '${date}T$normalizedTime', date];

  for (final candidate in candidates) {
    final parsed = DateTime.tryParse(candidate);
    if (parsed != null) {
      return parsed;
    }
  }

  final monthMatch = RegExp(
    r'^(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{1,2}),\s*(\d{4})$',
  ).firstMatch(date.trim());

  if (monthMatch != null) {
    const monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    final month = monthMap[monthMatch.group(1)!] ?? 1;
    final day = int.tryParse(monthMatch.group(2)!) ?? 1;
    final year = int.tryParse(monthMatch.group(3)!) ?? 1970;
    return DateTime(year, month, day);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}

class _EventMetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EventMetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
