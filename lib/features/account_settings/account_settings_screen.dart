import 'package:churchmsapp/features/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // Notification prefs
  bool contributionAlerts = false;
  bool eventReminders = false;
  bool announcements = false;

  // Privacy
  bool dataProcessing = false;
  bool shareProfile = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppHeader(showBackButton: true, onBack: () => Get.back()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your preferences',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 20),

                // Notification Preferences Card
                Text(
                  'Notification Preferences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _cardContainer(
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Contribution Alerts',
                        subtitle:
                            'Get notified when contributions are recorded',
                        value: contributionAlerts,
                        onChanged: (v) =>
                            setState(() => contributionAlerts = v),
                      ),
                      const Divider(height: 1),
                      _buildSwitchTile(
                        title: 'Event Reminders',
                        subtitle: 'Receive reminders for upcoming events',
                        value: eventReminders,
                        onChanged: (v) => setState(() => eventReminders = v),
                      ),
                      const Divider(height: 1),
                      _buildSwitchTile(
                        title: 'Announcements',
                        subtitle: 'Stay updated with church announcements',
                        value: announcements,
                        onChanged: (v) => setState(() => announcements = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Privacy & Consent
                Text(
                  'Privacy & Consent',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _cardContainer(
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Data Processing',
                        subtitle: 'Allow church to process your data',
                        value: dataProcessing,
                        onChanged: (v) => setState(() => dataProcessing = v),
                      ),
                      const Divider(height: 1),
                      _buildSwitchTile(
                        title: 'Share Profile',
                        subtitle: 'Make profile visible to other members',
                        value: shareProfile,
                        onChanged: (v) => setState(() => shareProfile = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Other Settings
                Text(
                  'Other Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _cardContainer(
                  child: Column(
                    children: [
                      _buildMenuTile(
                        title: 'Language',
                        trailing: 'English',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildMenuTile(title: 'Terms & Conditions', onTap: () {}),
                      const Divider(height: 1),
                      _buildMenuTile(title: 'Privacy Policy', onTap: () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      activeThumbColor: const Color(0xFF5B6FFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildMenuTile({
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(trailing, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
