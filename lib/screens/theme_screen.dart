import 'package:flutter/material.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

enum ThemeModeOption {
  deviceDefault,
  light,
  dark,
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeModeOption selectedOption = ThemeModeOption.light;

  void setThemeMode(ThemeModeOption? option) {
    setState(() {
      selectedOption = option!;
    });
    // You can save the theme preference here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.brightness_auto),
            title: Text('Device Default'),
            onTap: () => setThemeMode(ThemeModeOption.deviceDefault),
            trailing: Radio<ThemeModeOption>(
              value: ThemeModeOption.deviceDefault,
              groupValue: selectedOption,
              onChanged: (value) => setThemeMode(value),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_high),
            title: Text('Light Mode'),
            onTap: () => setThemeMode(ThemeModeOption.light),
            trailing: Radio<ThemeModeOption>(
              value: ThemeModeOption.light,
              groupValue: selectedOption,
              onChanged: (value) => setThemeMode(value),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_low),
            title: Text('Dark Mode'),
            onTap: () => setThemeMode(ThemeModeOption.dark),
            trailing: Radio<ThemeModeOption>(
              value: ThemeModeOption.dark,
              groupValue: selectedOption,
              onChanged: (value) => setThemeMode(value),
            ),
          ),
        ],
      ),
    );
  }
}
