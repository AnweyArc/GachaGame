import 'dart:async';
import 'package:flutter/material.dart';

class ShopItem {
  final String itemName;
  final int itemPrice;
  final String itemDescription;

  ShopItem({
    required this.itemName,
    required this.itemPrice,
    required this.itemDescription,
  });
}

class ShopInfo {
  // List of items in the shop
  static final List<ShopItem> items = [
    ShopItem(
      itemName: 'AutoClicker',
      itemPrice: 100000,
      itemDescription: 'Automatically clicks for you',
    ),
    ShopItem(
      itemName: 'Hold Clicker',
      itemPrice: 50000,
      itemDescription: 'Holds down the click for you',
    ),
    ShopItem(
      itemName: 'Card Fusion',
      itemPrice: 500000,
      itemDescription: 'Fuse cards for higher rewards',
    ),
    ShopItem(
      itemName: 'Prestige',
      itemPrice: 5000000,
      itemDescription: 'Prestige to reset for bonuses',
    ),
  ];

  // Function to handle AutoClicker functionality
  static Timer? _autoClickerTimer;
  static void autoClickerFunction(void Function() onCurrencyGenerated) {
    // Start a timer that triggers every second
    _autoClickerTimer = Timer.periodic(Duration(seconds: 1), (_) {
      // Call the onCurrencyGenerated function every second
      onCurrencyGenerated();
    });
  }

  // Function to stop the AutoClicker
  static void stopAutoClicker() {
    _autoClickerTimer?.cancel();
    _autoClickerTimer = null;
  }

  static void holdClickerFunction() {
    // Implement HoldClicker functionality
  }

  static void cardFusionFunction() {
    // Implement CardFusion functionality
  }

  static void prestigeFunction() {
    // Implement Prestige functionality
  }
}
