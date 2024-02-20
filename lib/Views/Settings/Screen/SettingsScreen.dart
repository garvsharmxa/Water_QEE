import 'package:flutter/material.dart';
import 'package:sample/Views/Profile/Screens/ProfileScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Settings
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: ListTile(
                title: const Text('Profile Settings'),
                subtitle: const Text('Edit your profile details'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            // Notification Settings
            GestureDetector(
              onTap: () {
                setState(() {
                  _receiveNotifications = !_receiveNotifications;
                });
              },
              child: ListTile(
                title: const Text('Notification Settings'),
                subtitle: Text(
                  _receiveNotifications ? 'Notifications are ON' : 'Notifications are OFF',
                ),
                trailing: Switch(
                  value: _receiveNotifications,
                  onChanged: (value) {
                    setState(() {
                      _receiveNotifications = value;
                    });
                  },
                ),
              ),
            ),

            // Account Settings
            GestureDetector(
              onTap: () {
                // Navigate to account settings
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()));
              },
              child: ListTile(
                title: const Text('Account Settings'),
                subtitle: const Text('Manage your account preferences'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
