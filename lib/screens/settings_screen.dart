import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_screen.dart';
import 'language_screen.dart';
import 'theme_screen.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  void toggleNotificationSettings(BuildContext context) {
    // Implement your logic for toggling notification settings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Enable Notifications'),
            trailing: Switch(
              value: true, // Use your own logic to determine the initial value
              onChanged: (value) => toggleNotificationSettings(context),
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications_off),
            title: Text('Disable Notifications'),
            trailing: Switch(
              value: false, // Use your own logic to determine the initial value
              onChanged: (value) => toggleNotificationSettings(context),
            ),
          ),
        ],
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed out successfully.'),
    
      ),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }


  void navigateToUserProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfileScreen()),
  );
}


   void toggleNotificationSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
    );
  }

   void navigateToThemeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThemeScreen()),
    );
  }

  void navigateToLanguageScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LanguageScreen()),
  );
}


  void navigateToPrivacySettings(BuildContext context) {
  }

  void checkForUpdates(BuildContext context) {
  }

  void navigateToHelpAndSupport(BuildContext context) {
  }

  void navigateToAbout(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
          leading: Icon(Icons.person),
          title: Text('User Profile'),
          onTap: () => navigateToUserProfile(context),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Settings'),
            onTap: () => toggleNotificationSettings(context),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            onTap: () => navigateToThemeScreen(context),
          ),
          ListTile(
          leading: Icon(Icons.language),
          title: Text('Language'),
          onTap: () => navigateToLanguageScreen(context),
          ),

          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Settings'),
            onTap: () => navigateToPrivacySettings(context),
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Check for Updates'),
            onTap: () => checkForUpdates(context),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () => navigateToHelpAndSupport(context),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () => navigateToAbout(context),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
