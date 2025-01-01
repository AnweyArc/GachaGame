import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_provider.dart'; // Import CurrencyProvider
import 'cards.dart'; // Import your card model

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

  // Load summoned cards and update quantities
  Future<void> _loadSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      summonedCards = prefs.getStringList('summonedCards') ?? [];
      cardQuantities = _calculateCardQuantities(summonedCards);
    });
  }

  // Calculate the quantity of each card
  Map<String, int> _calculateCardQuantities(List<String> cards) {
    Map<String, int> quantities = {};
    for (var card in cards) {
      quantities[card] = (quantities[card] ?? 0) + 1;
    }
    return quantities;
  }

  // Save the summoned cards data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

  // Sell a selected card
  void _sellCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    if (cardQuantities[cardRarity]! > 0) {
      setState(() {
        cardQuantities[cardRarity] = cardQuantities[cardRarity]! - 1;
        summonedCards.remove(cardRarity);

        // Remove the card from quantities if none are left
        if (cardQuantities[cardRarity]! <= 0) {
          cardQuantities.remove(cardRarity);
        }
      });

      currencyProvider.increaseCurrency(card.cost);
      _saveData(); // Save updated summonedCards list
    }
  }

  // Toggle the equipment status of a card
  void _toggleEquipCard(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    setState(() {
      if (equippedCards.contains(cardRarity)) {
        // Unequip the selected card
        equippedCards.remove(cardRarity);
        currencyProvider.unequipCard(card);
      } else {
        // Unequip all currently equipped cards
        equippedCards.forEach((equippedRarity) {
          final equippedCard = cardRarityList.firstWhere((card) => card.rarity == equippedRarity);
          currencyProvider.unequipCard(equippedCard);
        });

        equippedCards.clear(); // Clear all equipped cards

        // Equip the newly selected card if requirements are met
        if (cardQuantities[cardRarity]! >= card.equipQuantity) {
          equippedCards.add(cardRarity);
          currencyProvider.equipCard(card);
        }
      }
    });
  }

  // Function to show a dialog when selling a card
  void _showSellDialog(String cardRarity) {
    final card = cardRarityList.firstWhere((card) => card.rarity == cardRarity);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
    final totalAmount = card.cost * cardQuantities[cardRarity]!;

    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.sell, color: card.cardColor),
              SizedBox(width: 8),
              Text('Sell ${card.rarity} Card'),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Card Quantity: ${cardQuantities[cardRarity]!}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Sell By Amount',
                    hintText: 'Enter amount to sell',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final amountToSell = int.tryParse(amountController.text);
                        if (amountToSell != null && amountToSell > 0) {
                          setState(() {
                            // Update card quantity
                            cardQuantities[cardRarity] = cardQuantities[cardRarity]! - amountToSell;

                            // Remove the corresponding amount of cards from summonedCards list
                            for (int i = 0; i < amountToSell; i++) {
                              summonedCards.remove(cardRarity);
                            }

                            // If quantity becomes zero, remove the card from the inventory entirely
                            if (cardQuantities[cardRarity]! <= 0) {
                              cardQuantities.remove(cardRarity);
                            }
                          });

                          // Update currency and save data
                          currencyProvider.increaseCurrency(card.cost * amountToSell);
                          _saveData();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Sell'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Sell all of the cards
                          currencyProvider.increaseCurrency(totalAmount);
                          summonedCards.removeWhere((element) => element == cardRarity);
                          cardQuantities.remove(cardRarity); // Remove the card completely
                        });
                        _saveData();
                        Navigator.pop(context);
                      },
                      child: Text('Sell All'),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var groupedCards = groupBy(summonedCards, (String card) => card);
    var sortedGroupedCards = groupedCards.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    final currency = Provider.of<CurrencyProvider>(context).currency;
    final screenWidth = MediaQuery.of(context).size.width;

    int getCrossAxisCount() {
      if (screenWidth < 600) return 2;
      if (screenWidth < 900) return 3;
      return 4;
    }

    double getFontSize() {
      if (screenWidth < 600) return 14.0;
      if (screenWidth < 900) return 16.0;
      return 18.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory', style: TextStyle(fontSize: getFontSize() + 2)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Currency: $currency',
              style: TextStyle(fontSize: getFontSize()),
            ),
          ),
          Expanded(
            child: sortedGroupedCards.isEmpty
                ? Center(
                    child: Text(
                      'No cards in inventory.',
                      style: TextStyle(fontSize: getFontSize()),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
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
                            Expanded(
                              child: Image.asset(
                                card.imagePath, // Load card image
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$rarity x $count',
                              style: TextStyle(
                                color: card.cardColor,
                                fontWeight: FontWeight.bold,
                                fontSize: getFontSize(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text('Cost: ${card.cost}', style: TextStyle(fontSize: getFontSize())),
                            Text('Quantity to Equip: ${card.equipQuantity}', style: TextStyle(fontSize: getFontSize())),
                            Text('Multiplier: ${card.currencyMultiplier}x', style: TextStyle(fontSize: getFontSize())),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => _showSellDialog(rarity),
                                  child: Text(
                                    'Sell',
                                    style: TextStyle(color: card.cardColor, fontSize: getFontSize()),
                                  ),
                                ),
                                TextButton(
                                  onPressed: cardQuantities[rarity]! >= card.equipQuantity || equippedCards.contains(rarity)
                                      ? () => _toggleEquipCard(rarity)
                                      : null,
                                  child: Text(
                                    equippedCards.contains(rarity) ? 'Unequip' : 'Equip',
                                    style: TextStyle(color: card.cardColor, fontSize: getFontSize()),
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
