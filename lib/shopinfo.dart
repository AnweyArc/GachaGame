import 'package:flutter/material.dart';

// Define the Item class
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
      itemPrice: 100,
      itemDescription: 'Automatically clicks for you',
    ),
    ShopItem(
      itemName: 'Hold Clicker',
      itemPrice: 200,
      itemDescription: 'Holds down the click for you',
    ),
    ShopItem(
      itemName: 'Card Fusion',
      itemPrice: 500,
      itemDescription: 'Fuse cards for higher rewards',
    ),
    ShopItem(
      itemName: 'Prestige',
      itemPrice: 1000,
      itemDescription: 'Prestige to reset for bonuses',
    ),
  ];

  // Functions for item-related actions can be added here
  static void autoClickerFunction() {
    // Implement AutoClicker functionality
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
