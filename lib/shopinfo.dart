import 'dart:async';
import 'package:flutter/material.dart';

class ShopItem {
  final String itemName;
  final int itemPrice;
  final String itemDescription;
  final String category; // Add category field

  ShopItem({
    required this.itemName,
    required this.itemPrice,
    required this.itemDescription,
    required this.category, // Pass category in the constructor
  });
}

class ShopInfo {
  // List of items in the shop
  static final List<ShopItem> items = [
    ShopItem(
      itemName: 'AutoClicker',
      itemPrice: 100000,
      itemDescription: 'Automatically generates 10 currency per second multiplied by the equipped card',
      category: 'Equippable', // Category for equippable items
    ),
    ShopItem(
      itemName: 'Faster AutoClick',
      itemPrice: 200000,
      itemDescription: 'Twice as fast as the normal AutoClicker, generates 20 currency per second multiplied by the equipped card',
      category: 'Equippable', // Category for equippable items
    ),
    ShopItem(
      itemName: 'Hold Clicker',
      itemPrice: 50000,
      itemDescription: 'Holds down the click for you',
      category: 'Equippable', // Category for equippable items
    ),
    ShopItem(
      itemName: 'Card Fusion',
      itemPrice: 500000,
      itemDescription: 'Fuse cards for higher rewards',
      category: 'Upgrade', // Category for upgrades
    ),
    ShopItem(
      itemName: 'Prestige',
      itemPrice: 5000000,
      itemDescription: 'Prestige to reset for bonuses',
      category: 'Upgrade', // Category for upgrades
    ),
  ];

  // Function to handle AutoClicker functionality
  static Timer? _autoClickerTimer;
  static void autoClickerFunction(void Function() onCurrencyGenerated) {
    // Start a timer that triggers every second
    _autoClickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Call the onCurrencyGenerated function every second
      onCurrencyGenerated();
    });
  }

  // Function to handle Faster AutoClick functionality
  static Timer? _fasterAutoClickTimer;
  static void fasterAutoClickFunction(void Function() onCurrencyGenerated) {
    // Start a timer that triggers every half second
    _fasterAutoClickTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      // Call the onCurrencyGenerated function every half second
      onCurrencyGenerated();
    });
  }

  // Function to stop the AutoClicker
  static void stopAutoClicker() {
    _autoClickerTimer?.cancel();
    _autoClickerTimer = null;
  }

  // Function to stop the Faster AutoClicker
  static void stopFasterAutoClicker() {
    _fasterAutoClickTimer?.cancel();
    _fasterAutoClickTimer = null;
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
