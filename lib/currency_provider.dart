import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';
import 'shopinfo.dart';

class CurrencyProvider extends ChangeNotifier {
  int _currency = 0;
  double _currencyMultiplier = 1.0;
  CardModel? equippedCard;
  bool _isAutoClickerActive = false;
  Timer? _autoClickerTimer;

  int get currency => _currency;
  double get currencyMultiplier => _currencyMultiplier;
  bool get isAutoClickerActive => _isAutoClickerActive;

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getInt('currency') ?? 0;
    _isAutoClickerActive = prefs.getBool('autoClickerActive') ?? false;

    // Restore equipped card and reapply its multiplier
    int? equippedCardIndex = prefs.getInt('equippedCardIndex');
    if (equippedCardIndex != null &&
        equippedCardIndex >= 0 &&
        equippedCardIndex < cardRarityList.length) {
      equippedCard = cardRarityList[equippedCardIndex];
      _currencyMultiplier = equippedCard!.currencyMultiplier.toDouble(); // Cast to double
    } else {
      _currencyMultiplier = 1.0; // Default multiplier if no card is equipped
    }

    // Check if AutoClicker is equipped and active
    bool isAutoClickerEquipped = prefs.getBool('item_0_equipped') ?? false;
    if (isAutoClickerEquipped && _isAutoClickerActive) {
      startAutoClicker(2); // Start AutoClicker with default increment
    }
    notifyListeners();
  }

  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
    await prefs.setBool('autoClickerActive', _isAutoClickerActive);

    // Save equipped card
    if (equippedCard != null) {
      int equippedCardIndex = cardRarityList.indexOf(equippedCard!);
      await prefs.setInt('equippedCardIndex', equippedCardIndex);
    } else {
      await prefs.remove('equippedCardIndex');
    }
  }

  void increaseCurrency(int baseAmount) {
    _currency += (baseAmount * _currencyMultiplier).toInt();
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
    _currencyMultiplier = card.currencyMultiplier.toDouble(); // Cast to double
    saveCurrency();
    notifyListeners();
  }

  void unequipCard(CardModel card) {
    if (equippedCard == card) {
      _currencyMultiplier = 1.0; // Reset to default multiplier
      equippedCard = null;
      saveCurrency();
      notifyListeners();
    }
  }

  void startAutoClicker(int baseIncrementAmount) {
    if (!_isAutoClickerActive) {
      _isAutoClickerActive = true;

      int adjustedIncrementAmount =
          (baseIncrementAmount * _currencyMultiplier).toInt();
      _autoClickerTimer =
          Timer.periodic(Duration(seconds: 1), (timer) {
        increaseCurrency(adjustedIncrementAmount);
      });
      saveCurrency();
      notifyListeners();
    }
  }

  void stopAutoClicker() {
    _autoClickerTimer?.cancel();
    _isAutoClickerActive = false;
    saveCurrency();
    notifyListeners();
  }

  void resetAutoClickerState() {
    _isAutoClickerActive = false;
    _autoClickerTimer?.cancel();
  }
}
