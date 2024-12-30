import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';

class CurrencyProvider extends ChangeNotifier {
  int _currency = 0; // Default to 0, will be modified by SharedPreferences if loaded
  CardModel? equippedCard; // Track the equipped card

  int get currency => _currency;

  // Load the currency value from SharedPreferences
  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getInt('currency') ?? _currency; // Load from SharedPreferences or use the default
    notifyListeners(); // Notify listeners when currency is loaded
  }

  // Save the currency value to SharedPreferences
  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
  }

  // Increase the currency by a given value, factoring in the currencyMultiplier of the equipped card
  void increaseCurrency(int baseAmount) {
    final multiplier = equippedCard?.currencyMultiplier ?? 1; // Default multiplier is 1 if no card equipped
    _currency += baseAmount * multiplier;
    saveCurrency(); // Save updated currency value
    notifyListeners(); // Notify listeners about the change
  }

  // Decrease the currency by a given value
  void decreaseCurrency(int amount) {
    if (_currency >= amount) {
      _currency -= amount;
      saveCurrency(); // Save updated currency value
      notifyListeners(); // Notify listeners about the change
    }
  }

  // Equip a card, setting it as the currently active card
  void equipCard(CardModel card) {
    equippedCard = card;
    notifyListeners(); // Notify listeners when a new card is equipped
  }
}
