import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<String> languages = [
    'Arabic',
    'Chinese',
    'English',
    'French',
    'German',
    'Italian',
    'Japanese',
    'Korean',
    'Portuguese',
    'Russian',
    'Spanish',
    'Swedish'
  ];

  void selectLanguage(BuildContext context, String language) {
    setState(() {
      selectedLanguage = language;
    });

  }

  @override
  void initState() {
    super.initState();
    // Sort the languages list alphabetically
    languages.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Selection'),
      ),
      body: ListView.separated(
        itemCount: languages.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language == selectedLanguage;

          return ListTile(
            title: Text(
              language,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected ? Icon(Icons.check) : null,
            onTap: () => selectLanguage(context, language),
          );
        },
      ),
    );
  }
}
