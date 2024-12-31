import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';

class CurrencyProvider extends ChangeNotifier {
  int _currency = 0; // Currency should always be int
  double _currencyMultiplier = 1.0; // Multiplier should always be double
  CardModel? equippedCard; // Track the equipped card

  int get currency => _currency;
  double get currencyMultiplier => _currencyMultiplier;

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getInt('currency') ?? _currency;
    notifyListeners();
  }

  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
  }

  void increaseCurrency(int baseAmount) {
    _currency += (baseAmount * _currencyMultiplier).toInt(); // Correct type handling
    saveCurrency();
    notifyListeners();
  }

  void decreaseCurrency(int amount) {
    if (_currency >= amount) {
      _currency -= amount;
      saveCurrency();
      notifyListeners();
    }
  }

  void equipCard(CardModel card) {
    if (equippedCard != null) {
      unequipCard(equippedCard!);
    }
    equippedCard = card;
    _currencyMultiplier *= card.currencyMultiplier;
    notifyListeners();
  }

  void unequipCard(CardModel card) {
    if (equippedCard == card) {
      _currencyMultiplier /= card.currencyMultiplier;
      equippedCard = null;
      notifyListeners();
    }
  }
}
