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
  bool _isFasterAutoClickerActive = false;
  Timer? _autoClickerTimer;
  Timer? _fasterAutoClickerTimer;

  int get currency => _currency;
  double get currencyMultiplier => _currencyMultiplier;
  bool get isAutoClickerActive => _isAutoClickerActive;
  bool get isFasterAutoClickerActive => _isFasterAutoClickerActive;

  Future<void> loadCurrency() async {
  final prefs = await SharedPreferences.getInstance();
  _currency = prefs.getInt('currency') ?? 0;
  _isAutoClickerActive = prefs.getBool('autoClickerActive') ?? false;
  _isFasterAutoClickerActive = prefs.getBool('fasterAutoClickerActive') ?? false;
  
  print("Loaded fasterAutoClickerActive: $_isFasterAutoClickerActive"); // Debugging line

  // Restore equipped card and reapply its multiplier
  int? equippedCardIndex = prefs.getInt('equippedCardIndex');
  if (equippedCardIndex != null &&
      equippedCardIndex >= 0 &&
      equippedCardIndex < cardRarityList.length) {
    equippedCard = cardRarityList[equippedCardIndex];
    _currencyMultiplier = equippedCard!.currencyMultiplier.toDouble();
  } else {
    _currencyMultiplier = 1.0;
  }

  // Check if AutoClicker is equipped and active
  bool isAutoClickerEquipped = prefs.getBool('item_0_equipped') ?? false;
  if (isAutoClickerEquipped && _isAutoClickerActive) {
    startAutoClicker(2);
  }

  // Check if Faster AutoClicker is equipped and active
  bool isFasterAutoClickerEquipped = prefs.getBool('item_4_equipped') ?? false;
  if (isFasterAutoClickerEquipped && _isFasterAutoClickerActive) {
    startFasterAutoClicker(4);
  }

  notifyListeners();
}


  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currency', _currency);
    await prefs.setBool('autoClickerActive', _isAutoClickerActive);
    await prefs.setBool('fasterAutoClickerActive', _isFasterAutoClickerActive);

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
  // If Faster AutoClicker is active, stop it
  if (_isFasterAutoClickerActive) {
    stopFasterAutoClicker();
  }

  if (!_isAutoClickerActive) {
    _isAutoClickerActive = true;

    int adjustedIncrementAmount = (baseIncrementAmount * _currencyMultiplier).toInt();
    _autoClickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

void startFasterAutoClicker(int baseIncrementAmount) {
  // If AutoClicker is active, stop it
  if (_isAutoClickerActive) {
    stopAutoClicker();
  }

  if (!_isFasterAutoClickerActive) {
    print("Starting Faster AutoClicker...");

    _isFasterAutoClickerActive = true;

    int adjustedIncrementAmount = (baseIncrementAmount * _currencyMultiplier).toInt();
    _fasterAutoClickerTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      print("Increasing currency by $adjustedIncrementAmount"); 
      increaseCurrency(adjustedIncrementAmount);
    });

    saveCurrency();
    notifyListeners();
  } else {
    print("Faster AutoClicker already active.");
  }
}

void stopFasterAutoClicker() {
  _fasterAutoClickerTimer?.cancel();
  _isFasterAutoClickerActive = false;
  saveCurrency();
  notifyListeners();
}


}
