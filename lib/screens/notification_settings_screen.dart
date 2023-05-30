import 'package:flutter/material.dart';


class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isNotificationEnabled = false;
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;
  RangeValues _notificationVolumeRange = RangeValues(0.0, 1.0);

  void _toggleNotification(bool value) {
    setState(() {
      _isNotificationEnabled = value;
    });
    // Save the notification preference to the database or storage
    // or send the preference to the server
  }

  void _toggleSound(bool value) {
    setState(() {
      _isSoundEnabled = value;
    });
    // Save the sound preference to the database or storage
    // or send the preference to the server
  }

  void _toggleVibration(bool value) {
    setState(() {
      _isVibrationEnabled = value;
    });
    // Save the vibration preference to the database or storage
    // or send the preference to the server
  }

  void _setNotificationVolume(RangeValues values) {
    setState(() {
      _notificationVolumeRange = values;
    });
    // Save the notification volume preference to the database or storage
    // or send the preference to the server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _isNotificationEnabled,
            onChanged: _toggleNotification,
          ),
          Divider(),
          ListTile(
            title: Text('Notification Sound'),
            subtitle: Text('Play sound when receiving notifications'),
            trailing: Switch(
              value: _isSoundEnabled,
              onChanged: _toggleSound,
            ),
            onTap: () => _toggleSound(!_isSoundEnabled),
          ),
          ListTile(
            title: Text('Vibration'),
            subtitle: Text('Vibrate when receiving notifications'),
            trailing: Switch(
              value: _isVibrationEnabled,
              onChanged: _toggleVibration,
            ),
            onTap: () => _toggleVibration(!_isVibrationEnabled),
          ),
          Divider(),
          ListTile(
            title: Text('Notification Volume'),
            subtitle: RangeSlider(
              values: _notificationVolumeRange,
              onChanged: _setNotificationVolume,
            ),
          ),
        ],
      ),
    );
  }
}
