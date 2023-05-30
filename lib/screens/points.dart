import 'package:shared_preferences/shared_preferences.dart';

class Points {
  static int totalPoints = 0;
  static List<String> purchasedItems = [];

  static Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalPoints = prefs.getInt('totalPoints') ?? 100;
    purchasedItems = prefs.getStringList('purchasedItems') ?? [];
  }

  static Future<void> updatePoints(int newPoints) async {
    totalPoints = newPoints;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', totalPoints);
  }

  static Future<void> purchaseItem(String itemName) async {
    purchasedItems.add(itemName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('purchasedItems', purchasedItems);
  }
}