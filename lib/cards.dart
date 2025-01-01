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
    cost: 10,
    luckValue: 1,
    equipQuantity: 250,
    currencyValue: 10,
    currencyMultiplier: 2,
    cardColor: Colors.black,
    imagePath: 'assets/cardbackgrounds/Common.jpg',
  ),
  CardModel(
    rarity: 'Normal',
    cost: 20,
    luckValue: 2,
    equipQuantity: 200,
    currencyValue: 20,
    currencyMultiplier: 3,
    cardColor: Colors.green,
    imagePath: 'assets/cardbackgrounds/Normal.jpg',
  ),
  CardModel(
    rarity: 'Rare',
    cost: 50,
    luckValue: 5,
    equipQuantity: 170,
    currencyValue: 50,
    currencyMultiplier: 5,
    cardColor: Colors.blue,
    imagePath: 'assets/cardbackgrounds/Rare.jpg',
  ),
  CardModel(
    rarity: 'Epic',
    cost: 60,
    luckValue: 10,
    equipQuantity: 150,
    currencyValue: 100,
    currencyMultiplier: 7,
    cardColor: Colors.purple,
    imagePath: 'assets/cardbackgrounds/Epic.jpg',
  ),
  CardModel(
    rarity: 'Super Rare',
    cost: 80,
    luckValue: 20,
    equipQuantity: 120,
    currencyValue: 200,
    currencyMultiplier: 10,
    cardColor: Colors.orange,
    imagePath: 'assets/cardbackgrounds/SuperRare.jpg',
  ),
  CardModel(
    rarity: 'Ultra Rare',
    cost: 120,
    luckValue: 30,
    equipQuantity: 70,
    currencyValue: 500,
    currencyMultiplier: 13,
    cardColor: Colors.yellow,
    imagePath: 'assets/cardbackgrounds/UltraRare.jpg',
  ),
  CardModel(
    rarity: 'Ultimate',
    cost: 160,
    luckValue: 50,
    equipQuantity: 50,
    currencyValue: 1000,
    currencyMultiplier: 17,
    cardColor: Colors.deepPurple,
    imagePath: 'assets/cardbackgrounds/Ultimate.jpg',
  ),
  CardModel(
    rarity: 'Secret Rarity',
    cost: 500,
    luckValue: 100,
    equipQuantity: 20,
    currencyValue: 5000,
    currencyMultiplier: 20,
    cardColor: Colors.red,
    imagePath: 'assets/cardbackgrounds/SecretRarity.jpg',
  ),
  CardModel(
    rarity: 'Godly',
    cost: 1000,
    luckValue: 200,
    equipQuantity: 5,
    currencyValue: 10000,
    currencyMultiplier: 50,
    cardColor: Colors.redAccent,
    imagePath: 'assets/cardbackgrounds/Godly.jpg',
  ),
];
