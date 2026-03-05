import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class EventController extends GetxController {
  final RxList<EventItem> events = <EventItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiClient _client = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    isLoading.value = true;
    try {
      final resp = await _client.get('/api/member/events');
      final body = resp.data;
      if (body == null || (body is Map && body['success'] != true)) {
        errorMessage.value = 'Failed to load events';
        events.clear();
        return;
      }

      final data = (body is Map && body['data'] != null) ? body['data'] : body;
      final List items = (data is Map && data['events'] != null)
          ? (data['events'] as List)
          : (data is List ? data : []);

      final mapped = items.map<EventItem>((raw) {
        final id = (raw['id'] ?? '').toString();
        final title = (raw['title'] ?? raw['name'] ?? '').toString();
        final desc = (raw['description'] ?? '').toString();
        // Determine venue: prefer explicit location, fallback to branch name
        String venue = '';
        if (raw['location'] != null && raw['location'].toString().isNotEmpty) {
          venue = raw['location'].toString();
        } else if (raw['branch'] is Map && raw['branch']['name'] != null) {
          venue = raw['branch']['name'].toString();
        }

        final capacity = int.tryParse((raw['capacity'] ?? 0).toString()) ?? 0;
        final dateStr = (raw['event_date'] ?? raw['date'] ?? '').toString();
        // API does not provide time separately; leave empty
        final timeStr = '';
        final rsvpRequired = raw['rsvp_required'] == true;
        final attending = raw['is_attending'] == true;

        String formattedDate = dateStr;
        if (dateStr.isNotEmpty) {
          try {
            final dt = DateTime.parse(dateStr).toLocal();
            const monthNames = [
              '',
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
            ];
            formattedDate = '${monthNames[dt.month]} ${dt.day}, ${dt.year}';
          } catch (_) {}
        }

        String formattedTime = timeStr;
        // time not provided by API; leave formattedTime as empty string

        return EventItem(
          id: id,
          title: title,
          description: desc,
          venue: venue,
          capacity: capacity,
          date: formattedDate,
          time: formattedTime,
          rsvpRequired: rsvpRequired,
          isAttending: attending,
        );
      }).toList();

      events.assignAll(mapped);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch events: $e';
      events.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rsvp(String eventId) async {
    try {
      await _client.post('/api/member/event/$eventId/rsvp');
      // Optimistically mark attending
      final idx = events.indexWhere((e) => e.id == eventId);
      if (idx >= 0) {
        final cur = events[idx];
        events[idx] = cur.copyWith(isAttending: true);
      }
    } catch (_) {}
  }

  Future<void> cancelRsvp(String eventId) async {
    try {
      await _client.post('/api/member/event/$eventId/cancel-rsvp');
      final idx = events.indexWhere((e) => e.id == eventId);
      if (idx >= 0) {
        final cur = events[idx];
        events[idx] = cur.copyWith(isAttending: false);
      }
    } catch (_) {}
  }
}

class EventItem {
  final String id;
  final String title;
  final String description;
  final String venue;
  final int capacity;
  final String date;
  final String time;
  final bool rsvpRequired;
  final bool isAttending;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.capacity,
    required this.date,
    required this.time,
    this.rsvpRequired = false,
    this.isAttending = false,
  });

  EventItem copyWith({
    String? id,
    String? title,
    String? description,
    String? venue,
    int? capacity,
    String? date,
    String? time,
    bool? rsvpRequired,
    bool? isAttending,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      venue: venue ?? this.venue,
      capacity: capacity ?? this.capacity,
      date: date ?? this.date,
      time: time ?? this.time,
      rsvpRequired: rsvpRequired ?? this.rsvpRequired,
      isAttending: isAttending ?? this.isAttending,
    );
  }
}
