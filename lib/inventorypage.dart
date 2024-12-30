import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_provider.dart';  // Import CurrencyProvider
import 'cards.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<String> summonedCards = [];
  Map<String, int> cardQuantities = {}; // Track the quantity of each card

  @override
  void initState() {
    super.initState();
    _loadSummonedCards();
  }

  // Load the summoned cards from SharedPreferences
  Future<void> _loadSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      summonedCards = prefs.getStringList('summonedCards') ?? [];
      cardQuantities = _calculateCardQuantities(summonedCards);
    });
  }

  // Calculate the quantities of each card
  Map<String, int> _calculateCardQuantities(List<String> cards) {
    Map<String, int> quantities = {};
    for (var card in cards) {
      quantities[card] = (quantities[card] ?? 0) + 1;
    }
    return quantities;
  }

  // Save the summoned cards to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

  // Sell the card and add its cost to the currency using CurrencyProvider
  void _sellCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false); // Get the provider

    if (cardQuantities[cardRarity]! > 0) {
      setState(() {
        cardQuantities[cardRarity] = cardQuantities[cardRarity]! - 1;
        summonedCards.remove(cardRarity); // Remove the card from summoned list
      });

      currencyProvider.increaseCurrency(card.cost); // Add the card's cost to the currency using the provider
      _saveData(); // Save the updated data
    }
  }

  // Equip the card
  void _equipCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    if (cardQuantities[cardRarity]! >= card.equipQuantity) {
      // Equip the card by updating the CurrencyProvider
      currencyProvider.equipCard(card);

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Card Equipped'),
            content: Text('You have equipped the $cardRarity card!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group cards by rarity
    var groupedCards = groupBy(summonedCards, (String card) => card);

    // Sort the groups by the count in descending order
    var sortedGroupedCards = groupedCards.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    // Get the current currency from the provider
    final currency = Provider.of<CurrencyProvider>(context).currency;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: Column(
        children: [
          // Display the current currency from the provider
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Current Currency: $currency'),
          ),
          // Display the inventory list
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
                            // Sell Button
                            TextButton(
                              onPressed: () => _sellCard(rarity),
                              child: Text('Sell'),
                            ),
                            // Equip Button (enabled if quantity >= equipQuantity)
                            TextButton(
                              onPressed: cardQuantities[rarity]! >= card.equipQuantity
                                  ? () => _equipCard(rarity)
                                  : null, // Disable if not enough quantity
                              child: Text('Equip'),
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
