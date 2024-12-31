import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_provider.dart'; // Import CurrencyProvider
import 'cards.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<String> summonedCards = [];
  Map<String, int> cardQuantities = {};
  Set<String> equippedCards = {}; // Track equipped cards

  @override
  void initState() {
    super.initState();
    _loadSummonedCards();
  }

  Future<void> _loadSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      summonedCards = prefs.getStringList('summonedCards') ?? [];
      cardQuantities = _calculateCardQuantities(summonedCards);
    });
  }

  Map<String, int> _calculateCardQuantities(List<String> cards) {
    Map<String, int> quantities = {};
    for (var card in cards) {
      quantities[card] = (quantities[card] ?? 0) + 1;
    }
    return quantities;
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

  void _sellCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    if (cardQuantities[cardRarity]! > 0) {
      setState(() {
        cardQuantities[cardRarity] = cardQuantities[cardRarity]! - 1;
        summonedCards.remove(cardRarity);
      });

      currencyProvider.increaseCurrency(card.cost);
      _saveData();
    }
  }

  void _toggleEquipCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    setState(() {
      if (equippedCards.contains(cardRarity)) {
        equippedCards.remove(cardRarity);
        currencyProvider.unequipCard(card);
      } else if (cardQuantities[cardRarity]! >= card.equipQuantity) {
        equippedCards.add(cardRarity);
        currencyProvider.equipCard(card);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupedCards = groupBy(summonedCards, (String card) => card);
    var sortedGroupedCards = groupedCards.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    final currency = Provider.of<CurrencyProvider>(context).currency;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Current Currency: $currency'),
          ),
          Expanded(
            child: sortedGroupedCards.isEmpty
                ? Center(child: Text('No cards in inventory.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7, // Adjust for the card proportions
                    ),
                    itemCount: sortedGroupedCards.length,
                    itemBuilder: (context, index) {
                      var rarity = sortedGroupedCards[index].key;
                      var count = sortedGroupedCards[index].value.length;
                      var card = cardRarityList.firstWhere((card) => card.rarity == rarity);

                      return Card(
                        color: card.cardColor.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$rarity x $count',
                              style: TextStyle(
                                color: card.cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text('Cost: ${card.cost}'),
                            Text('Equip: ${card.equipQuantity}'),
                            Text('Multiplier: ${card.currencyMultiplier}x'),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => _sellCard(rarity),
                                  child: Text(
                                    'Sell',
                                    style: TextStyle(color: card.cardColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: cardQuantities[rarity]! >= card.equipQuantity || equippedCards.contains(rarity)
                                      ? () => _toggleEquipCard(rarity)
                                      : null,
                                  child: Text(
                                    equippedCards.contains(rarity) ? 'Unequip' : 'Equip',
                                    style: TextStyle(color: card.cardColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
