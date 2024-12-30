class CardModel {
  final String rarity;
  final int cost;
  final int luckValue;
  final int currencyValue;
  final String specialEffect;

  // Constructor
  CardModel({
    required this.rarity,
    required this.cost,
    required this.luckValue,
    required this.currencyValue,
    required this.specialEffect,
  });

  // Optional: To easily print the card information
  @override
  String toString() {
    return '$rarity Card (Cost: $cost, Luck Value: $luckValue, Currency Value: $currencyValue, Special Effect: $specialEffect)';
  }
}

// Example card instances
List<CardModel> cardList = [
  CardModel(
    rarity: 'Common',
    cost: 50,
    luckValue: 1,
    currencyValue: 10,
    specialEffect: 'No special effect',
  ),
  CardModel(
    rarity: 'Normal',
    cost: 100,
    luckValue: 2,
    currencyValue: 20,
    specialEffect: 'Increase drop rate slightly',
  ),
  CardModel(
    rarity: 'Rare',
    cost: 200,
    luckValue: 5,
    currencyValue: 50,
    specialEffect: 'Increase luck by 10%',
  ),
  CardModel(
    rarity: 'Epic',
    cost: 500,
    luckValue: 10,
    currencyValue: 100,
    specialEffect: 'Increases summon chances for higher rarity cards',
  ),
  CardModel(
    rarity: 'Super Rare',
    cost: 1000,
    luckValue: 20,
    currencyValue: 200,
    specialEffect: 'Double currency value from summons',
  ),
  CardModel(
    rarity: 'Ultra Rare',
    cost: 2000,
    luckValue: 30,
    currencyValue: 500,
    specialEffect: 'Boosts chances of summoning Secret Rarity cards',
  ),
  CardModel(
    rarity: 'Ultimate',
    cost: 5000,
    luckValue: 50,
    currencyValue: 1000,
    specialEffect: 'Grants the ability to summon Godly cards',
  ),
  CardModel(
    rarity: 'Secret Rarity',
    cost: 10000,
    luckValue: 100,
    currencyValue: 5000,
    specialEffect: 'Special effect grants 100% luck for next summon',
  ),
  CardModel(
    rarity: 'Godly',
    cost: 50000,
    luckValue: 200,
    currencyValue: 10000,
    specialEffect: 'Instant win, doubles all current currency',
  ),
];
