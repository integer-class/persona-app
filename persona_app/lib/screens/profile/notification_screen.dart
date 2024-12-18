import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationService = NotificationService();
  bool isDailyReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Daily Reminder'),
            subtitle: const Text('Get reminded to check your style recommendations daily'),
            trailing: Switch(
              value: _notificationService.isDailyReminderEnabled, // Use service state
              onChanged: (value) {
                setState(() {
                  _notificationService.scheduleDailyReminder(value);
                });
              },
              activeColor: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}