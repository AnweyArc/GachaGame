class CardModel {
  final String rarity;
  final int cost;
  final int luckValue;
  final int currencyValue;
  final int equipQuantity;
  final int currencyMultiplier; // New attribute

  // Constructor
  CardModel({
    required this.rarity,
    required this.cost,
    required this.luckValue,
    required this.currencyValue,
    required this.equipQuantity,
    required this.currencyMultiplier, // Initialize new attribute
  });

  // Optional: To easily print the card information
  @override
  String toString() {
    return '$rarity Card (Cost: $cost, Luck Value: $luckValue, Currency Value: $currencyValue, Equip Quantity: $equipQuantity, Currency Multiplier: $currencyMultiplier)';
  }
}

// Example card instances
List<CardModel> cardRarityList = [
  CardModel(
    rarity: 'Common',
    cost: 10,
    luckValue: 1,
    equipQuantity: 500,
    currencyValue: 10,
    currencyMultiplier: 2, // New value
  ),
  CardModel(
    rarity: 'Normal',
    cost: 20,
    luckValue: 2,
    equipQuantity: 250,
    currencyValue: 20,
    currencyMultiplier: 3, // New value
  ),
  CardModel(
    rarity: 'Rare',
    cost: 50,
    luckValue: 5,
    equipQuantity: 150,
    currencyValue: 50,
    currencyMultiplier: 5, // New value
  ),
  CardModel(
    rarity: 'Epic',
    cost: 60,
    luckValue: 10,
    equipQuantity: 100,
    currencyValue: 100,
    currencyMultiplier: 7, // New value
  ),
  CardModel(
    rarity: 'Super Rare',
    cost: 80,
    luckValue: 20,
    equipQuantity: 75,
    currencyValue: 200,
    currencyMultiplier: 10, // New value
  ),
  CardModel(
    rarity: 'Ultra Rare',
    cost: 120,
    luckValue: 30,
    equipQuantity: 50,
    currencyValue: 500,
    currencyMultiplier: 13, // New value
  ),
  CardModel(
    rarity: 'Ultimate',
    cost: 160,
    luckValue: 50,
    equipQuantity: 25,
    currencyValue: 1000,
    currencyMultiplier: 17, // New value
  ),
  CardModel(
    rarity: 'Secret Rarity',
    cost: 500,
    luckValue: 100,
    equipQuantity: 10,
    currencyValue: 5000,
    currencyMultiplier: 20, // New value
  ),
  CardModel(
    rarity: 'Godly',
    cost: 1000,
    luckValue: 200,
    equipQuantity: 5,
    currencyValue: 10000,
    currencyMultiplier: 50, // New value
  ),
];
