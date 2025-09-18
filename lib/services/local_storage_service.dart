import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favorites", favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("favorites") ?? [];
  }
}
