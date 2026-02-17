import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = [
      AnnouncementModel(
        title: 'Sunday Service Time Cha...',
        description:
            'Starting next week, Sunday service will begin at 9:00 AM instead of 10:00...',
        source: 'Church Admin',
        date: '2026-02-15',
        isNew: true,
      ),
      AnnouncementModel(
        title: 'Youth Camp Registration ...',
        description:
            'Registration for the annual youth camp is now open. Limited slots available...',
        source: 'Youth Department',
        date: '2026-02-10',
        isNew: true,
      ),
      AnnouncementModel(
        title: 'Monthly Prayer Meeting',
        description:
            'Join us for our monthly prayer meeting this Friday at 6:00 PM...',
        source: 'Prayer Team',
        date: '2026-02-05',
        isNew: false,
      ),
      AnnouncementModel(
        title: 'Building Fund Update',
        description:
            'We are excited to share that we have reached 75% of our building fund...',
        source: 'Finance Team',
        date: '2026-02-01',
        isNew: false,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Text(
          'Announcements',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Stay updated with church news',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 16),
        ...announcements.map((announcement) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AnnouncementCard(announcement: announcement),
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }
}

class AnnouncementModel {
  final String title;
  final String description;
  final String source;
  final String date;
  final bool isNew;

  AnnouncementModel({
    required this.title,
    required this.description,
    required this.source,
    required this.date,
    this.isNew = false,
  });
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.send_outlined,
                  color: Colors.blue.shade400,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            announcement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (announcement.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      announcement.description,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          announcement.source,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          announcement.date,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
