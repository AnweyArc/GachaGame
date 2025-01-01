import 'package:flutter/material.dart';

class CardModel {
  final String rarity;
  final int cost;
  final int luckValue;
  final int currencyValue;
  final int equipQuantity;
  final int currencyMultiplier;
  final Color cardColor; // Card color
  final String imagePath; // New attribute for image path

  // Constructor
  CardModel({
    required this.rarity,
    required this.cost,
    required this.luckValue,
    required this.currencyValue,
    required this.equipQuantity,
    required this.currencyMultiplier,
    required this.cardColor,
    required this.imagePath, // Initialize the new attribute
  });

  // Optional: To easily print the card information
  @override
  String toString() {
    return '$rarity Card (Cost: $cost, Luck Value: $luckValue, Currency Value: $currencyValue, Equip Quantity: $equipQuantity, Currency Multiplier: $currencyMultiplier, Color: $cardColor, ImagePath: $imagePath)';
  }
}

// Example card instances
List<CardModel> cardRarityList = [
  CardModel(
    rarity: 'Common',
    cost: 15,
    luckValue: 2,
    equipQuantity: 200,
    currencyValue: 15,
    currencyMultiplier: 2,
    cardColor: Colors.black,
    imagePath: 'assets/cardbackgrounds/Common.jpg',
  ),
  CardModel(
    rarity: 'Normal',
    cost: 30,
    luckValue: 3,
    equipQuantity: 180,
    currencyValue: 30,
    currencyMultiplier: 4,
    cardColor: Colors.green,
    imagePath: 'assets/cardbackgrounds/Normal.jpg',
  ),
  CardModel(
    rarity: 'Rare',
    cost: 60,
    luckValue: 6,
    equipQuantity: 160,
    currencyValue: 60,
    currencyMultiplier: 6,
    cardColor: Colors.blue,
    imagePath: 'assets/cardbackgrounds/Rare.jpg',
  ),
  CardModel(
    rarity: 'Epic',
    cost: 200,
    luckValue: 12,
    equipQuantity: 140,
    currencyValue: 120,
    currencyMultiplier: 8,
    cardColor: Colors.purple,
    imagePath: 'assets/cardbackgrounds/Epic.jpg',
  ),
  CardModel(
    rarity: 'Super Rare',
    cost: 600,
    luckValue: 25,
    equipQuantity: 110,
    currencyValue: 250,
    currencyMultiplier: 12,
    cardColor: Colors.orange,
    imagePath: 'assets/cardbackgrounds/SuperRare.jpg',
  ),
  CardModel(
    rarity: 'Ultra Rare',
    cost: 1200,
    luckValue: 35,
    equipQuantity: 60,
    currencyValue: 600,
    currencyMultiplier: 15,
    cardColor: Colors.yellow,
    imagePath: 'assets/cardbackgrounds/UltraRare.jpg',
  ),
  CardModel(
    rarity: 'Ultimate',
    cost: 17000,
    luckValue: 55,
    equipQuantity: 40,
    currencyValue: 1200,
    currencyMultiplier: 20,
    cardColor: Colors.deepPurple,
    imagePath: 'assets/cardbackgrounds/Ultimate.jpg',
  ),
  CardModel(
    rarity: 'Secret Rarity',
    cost: 60000,
    luckValue: 120,
    equipQuantity: 15,
    currencyValue: 6000,
    currencyMultiplier: 25,
    cardColor: Colors.red,
    imagePath: 'assets/cardbackgrounds/SecretRarity.jpg',
  ),
  CardModel(
    rarity: 'Godly',
    cost: 120000,
    luckValue: 220,
    equipQuantity: 3,
    currencyValue: 12000,
    currencyMultiplier: 60,
    cardColor: Colors.redAccent,
    imagePath: 'assets/cardbackgrounds/Godly.jpg',
  ),
];
