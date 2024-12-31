import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'inventorypage.dart'; // Import the InventoryPage
import 'package:shared_preferences/shared_preferences.dart';
import 'cards.dart';

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
    'Godly',
  ];

  final Map<String, double> rarityChances = {
    'Common': 50.0,
    'Normal': 20.0,
    'Rare': 10.0,
    'Epic': 5.0,
    'Super Rare': 1.0,
    'Ultra Rare': 0.002,
    'Ultimate': 0.0008,
    'Secret Rarity': 0.0002,
    'Godly': 0.000001,
  };

  List<String> summonedCards = [];

  @override
  void initState() {
    super.initState();
    _loadSummonedCards();
  }

  Future<void> _loadSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      summonedCards = prefs.getStringList('summonedCards') ?? [];
    });
  }

  Future<void> _saveSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

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
    int summonCost = 25 * count;

    if (currencyProvider.currency >= summonCost) {
      setState(() {
        for (int i = 0; i < count; i++) {
          summonedCards.add(_summonCard());
        }
        currencyProvider.decreaseCurrency(summonCost);
      });
      _saveSummonedCards();
    } else {
      _showNotEnoughCurrencyMessage();
    }
  }

  void _showNotEnoughCurrencyMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Insufficient Currency"),
          content: Text("You do not have enough currency to summon cards."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCardDetails(String rarity) {
    String? imagePath = cardRarityList
        .firstWhere(
          (card) => card.rarity == rarity,
          orElse: () => CardModel(
            rarity: 'Unknown',
            cost: 0,
            luckValue: 0,
            equipQuantity: 0,
            currencyValue: 0,
            currencyMultiplier: 0,
            cardColor: Colors.grey,
            imagePath: 'assets/cardbackgrounds/default.png',
          ),
        )
        .imagePath;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailsPage(rarity: rarity, imagePath: imagePath),
      ),
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
          Text(
            'Currency: ${currencyProvider.currency}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'Summon your cards!',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _performSummon(1, currencyProvider),
                child: Text('Summon x1 (25 Currency)'),
              ),
              ElevatedButton(
                onPressed: () => _performSummon(5, currencyProvider),
                child: Text('Summon x5 (125 Currency)'),
              ),
              ElevatedButton(
                onPressed: () => _performSummon(10, currencyProvider),
                child: Text('Summon x10 (250 Currency)'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryPage()),
              ).then((_) => _loadSummonedCards());
            },
            child: Text('View Inventory'),
          ),
          SizedBox(height: 20),
          Text(
            'Recently Summoned Cards:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          summonedCards.isEmpty
              ? Text('No cards summoned yet.')
              : Container(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: summonedCards.take(10).length,
                    itemBuilder: (context, index) {
                      String rarity = summonedCards[summonedCards.length - 1 - index];
                      return GestureDetector(
                        onTap: () => _showCardDetails(rarity),
                        child: Image.asset(
                          cardRarityList
                              .firstWhere(
                                (card) => card.rarity == rarity,
                                orElse: () => CardModel(
                                  rarity: 'Unknown',
                                  cost: 0,
                                  luckValue: 0,
                                  equipQuantity: 0,
                                  currencyValue: 0,
                                  currencyMultiplier: 0,
                                  cardColor: Colors.grey,
                                  imagePath: 'assets/cardbackgrounds/default.png',
                                ),
                              )
                              .imagePath,
                          fit: BoxFit.cover,
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

class CardDetailsPage extends StatelessWidget {
  final String rarity;
  final String? imagePath;

  CardDetailsPage({required this.rarity, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rarity),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath ?? 'assets/cardbackgrounds/default.png', fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              'Rarity: $rarity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This is a detailed description of the card with rarity $rarity.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
