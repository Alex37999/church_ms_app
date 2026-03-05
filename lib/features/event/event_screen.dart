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
      body: Column(
        children: [
          const AppHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctrl.errorMessage.value.isNotEmpty) {
                return Center(child: Text(ctrl.errorMessage.value));
              }

              if (ctrl.events.isEmpty) {
                return const Center(child: Text('No upcoming events'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: ctrl.events.length,
                itemBuilder: (context, idx) {
                  final e = ctrl.events[idx];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
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
                              child: ElevatedButton(
                                onPressed: () => ctrl.rsvp(e.id),
                                child: const Text("RSVP - I'm Attending"),
                              ),
                            ),
                          if (e.rsvpRequired && e.isAttending)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                                onPressed: () => ctrl.cancelRsvp(e.id),
                                child: const Text('Cancel RSVP'),
                              ),
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
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
