import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  // Default currency value, can be modified by commenting/uncommenting the below line
  // int _currency = 1000;  // Uncomment this for hardcoded default value

  int _currency = 0;  // Default to 0, will be modified by SharedPreferences if loaded

  int get currency => _currency;

  // Load the currency value from SharedPreferences
  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Optionally, uncomment the line below to hardcode the initial value
    // _currency = 1000; // Set hardcoded value, uncomment to use it
    _currency = prefs.getInt('currency') ?? _currency;  // Load from SharedPreferences or use the default
    notifyListeners(); // Notify listeners when currency is loaded
  }

  // Save the currency value to SharedPreferences
  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
  }

  // Increase the currency by a given value
  void increaseCurrency(int amount) {
    _currency += amount;
    saveCurrency();  // Save updated currency value
    notifyListeners(); // Notify listeners about the change
  }

  // Decrease the currency by a given value
  void decreaseCurrency(int amount) {
    if (_currency >= amount) {
      _currency -= amount;
      saveCurrency();  // Save updated currency value
      notifyListeners(); // Notify listeners about the change
    }
  }
}
