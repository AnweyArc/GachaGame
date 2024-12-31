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

  // Load summoned cards from SharedPreferences
  Future<void> _loadSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      summonedCards = prefs.getStringList('summonedCards') ?? [];
      cardQuantities = _calculateCardQuantities(summonedCards);
    });
  }

  // Calculate card quantities
  Map<String, int> _calculateCardQuantities(List<String> cards) {
    Map<String, int> quantities = {};
    for (var card in cards) {
      quantities[card] = (quantities[card] ?? 0) + 1;
    }
    return quantities;
  }

  // Save summoned cards to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

  // Sell a card and add its cost to currency
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

  // Toggle equip/unequip card
  void _toggleEquipCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    setState(() {
      if (equippedCards.contains(cardRarity)) {
        // Unequip the card
        equippedCards.remove(cardRarity);
        currencyProvider.unequipCard(card);
      } else if (cardQuantities[cardRarity]! >= card.equipQuantity) {
        // Equip the card
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
                : ListView.builder(
                    itemCount: sortedGroupedCards.length,
                    itemBuilder: (context, index) {
                      var rarity = sortedGroupedCards[index].key;
                      var count = sortedGroupedCards[index].value.length;
                      var card = cardRarityList.firstWhere((card) => card.rarity == rarity);

                      return ListTile(
                        title: Text('$rarity x $count'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cost: ${card.cost}'),
                            Text('Equip Requirement: ${card.equipQuantity}'),
                            Text('Currency Multiplier: ${card.currencyMultiplier}x'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => _sellCard(rarity),
                              child: Text('Sell'),
                            ),
                            TextButton(
                              onPressed: cardQuantities[rarity]! >= card.equipQuantity || equippedCards.contains(rarity)
                                  ? () => _toggleEquipCard(rarity)
                                  : null,
                              child: Text(equippedCards.contains(rarity) ? 'Unequip' : 'Equip'),
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
