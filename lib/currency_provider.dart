import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';

class CurrencyProvider extends ChangeNotifier {
  int _currency = 0; // Default to 0, will be modified by SharedPreferences if loaded
  double _currencyMultiplier = 1.0; // Default multiplier
  CardModel? equippedCard; // Track the equipped card

  int get currency => _currency;
  double get currencyMultiplier => _currencyMultiplier;

  // Load the currency value from SharedPreferences
  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getInt('currency') ?? _currency;
    notifyListeners(); // Notify listeners when currency is loaded
  }

  // Save the currency value to SharedPreferences
  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
  }

  // Increase the currency by a given value, factoring in the currencyMultiplier
  void increaseCurrency(int baseAmount) {
    _currency += (baseAmount * _currencyMultiplier).toInt();
    saveCurrency();
    notifyListeners();
  }

  // Decrease the currency by a given value
  void decreaseCurrency(int amount) {
    if (_currency >= amount) {
      _currency -= amount;
      saveCurrency();
      notifyListeners();
    }
  }

  // Equip a card, updating the currency multiplier
  void equipCard(CardModel card) {
    equippedCard = card;
    _currencyMultiplier *= card.currencyMultiplier;
    notifyListeners();
  }

  // Unequip a card, resetting the multiplier
  void unequipCard(CardModel card) {
    if (equippedCard == card) {
      _currencyMultiplier /= card.currencyMultiplier;
      equippedCard = null;
      notifyListeners();
    }
  }
}
