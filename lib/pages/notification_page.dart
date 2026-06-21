import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {'title': 'New Launch Article Available!', 'time': 'Just now'},
      {'title': 'SpaceX updates structural updates on Starship.', 'time': '2 hours ago'},
      {'title': 'Welcome to SpaceNews Core Application!', 'time': '1 day ago'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey[200], height: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.deepPurple),
            title: Text(item['title']!),
            subtitle: Text(item['time']!),
          );
        },
      ),
    );
  }
}