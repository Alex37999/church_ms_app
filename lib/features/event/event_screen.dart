import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      backgroundColor: const Color(0xFFF7F8FA),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: ctrl.fetchEvents,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const AppHeader(),
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
                        color: Colors.black54,
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
                ...ctrl.events.map((e) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${e.date} ${e.time}'.trim(),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    e.venue,
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${e.capacity} capacity',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(e.description),
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
                                      side: const BorderSide(color: Colors.red),
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
                }).toList(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
