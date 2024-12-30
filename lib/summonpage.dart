import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'inventorypage.dart'; // Import the InventoryPage

class SummonPage extends StatefulWidget {
  @override
  _SummonPageState createState() => _SummonPageState();
}

class _SummonPageState extends State<SummonPage> {
  final List<String> rarities = [
    'Common',
    'Normal',
    'Rare',
    'Epic',
    'Super Rare',
    'Ultra Rare',
    'Ultimate',
    'Secret Rarity',
    'Godly'
  ];

  final Map<String, double> rarityChances = {
    'Common': 50.0,
    'Normal': 25.0,
    'Rare': 12.0,
    'Epic': 6.0,
    'Super Rare': 4.0,
    'Ultra Rare': 2.0,
    'Ultimate': 0.008,
    'Secret Rarity': 0.002,
    'Godly': 0.000001
  };

  List<String> summonedCards = [];

  String _summonCard() {
    double randomValue = Random().nextDouble() * 100;
    double cumulative = 0.0;
    for (var rarity in rarities) {
      cumulative += rarityChances[rarity]!;
      if (randomValue <= cumulative) {
        return rarity;
      }
    }
    return 'Common';
  }

  void _performSummon(int count, CurrencyProvider currencyProvider) {
    int summonCost = 160 * count; // 160 per summon
    if (currencyProvider.currency >= summonCost) {
      setState(() {
        for (int i = 0; i < count; i++) {
          summonedCards.add(_summonCard());
        }
        currencyProvider.decreaseCurrency(summonCost); // Decrease the currency
      });
    } else {
      _showNotEnoughCurrencyMessage(); // Show message if currency is insufficient
    }
  }

  void _showNotEnoughCurrencyMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Currency not enough!"),
          content: Text("Click more!"),
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

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Summon Cards'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Currency: ${currencyProvider.currency}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Text('Summon your cards!', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _performSummon(1, currencyProvider),
                child: Text('Summon x1 (160 Currency)'),
              ),
              ElevatedButton(
                onPressed: () => _performSummon(5, currencyProvider),
                child: Text('Summon x5 (800 Currency)'),
              ),
              ElevatedButton(
                onPressed: () => _performSummon(10, currencyProvider),
                child: Text('Summon x10 (1600 Currency)'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the inventory page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryPage(summonedCards: summonedCards)),
              );
            },
            child: Text('View Inventory'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: summonedCards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(summonedCards[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
