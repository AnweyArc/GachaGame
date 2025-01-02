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

class _SummonPageState extends State<SummonPage> with SingleTickerProviderStateMixin {
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
    'Common': 45.0,
    'Normal': 18.0,
    'Rare': 9.0,
    'Epic': 4.0,
    'Super Rare': 1.0,
    'Ultra Rare': 0.003,
    'Ultimate': 0.001,
    'Secret Rarity': 0.0003,
    'Godly': 0.0000002,
  };

  final Map<String, double> mysticRarityChances = {
    'Ultra Rare': 20.0,
    'Ultimate': 15.0,
    'Secret Rarity': 10.0,
    'Godly': 1.0,
  };

  List<String> summonedCards = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
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

  String _summonCard({bool isMystic = false}) {
    double randomValue = Random().nextDouble() * 100;
    double cumulative = 0.0;

    Map<String, double> chances = isMystic ? mysticRarityChances : rarityChances;

    for (var rarity in chances.keys) {
      cumulative += chances[rarity]!;

      if (randomValue <= cumulative) {
        return rarity;
      }
    }
    return 'Common';
  }

  Future<void> _performMysticSummon(CurrencyProvider currencyProvider) async {
    int summonCost = 100000;

    if (currencyProvider.currency >= summonCost) {
      setState(() {
        String summonedCard = _summonCard(isMystic: true);
        summonedCards.add(summonedCard);
        currencyProvider.decreaseCurrency(summonCost);
      });
      _saveSummonedCards();

      // Flash effect and display summoned card
      await _showFlashEffect();
      String summonedCard = summonedCards.last;
      _showCardDetails(summonedCard);
    } else {
      _showNotEnoughCurrencyMessage();
    }
  }

  Future<void> _showFlashEffect() async {
  // Get the size of the device's screen
  final screenSize = MediaQuery.of(context).size;

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
      builder: (context, child) {
        // Responsive positioning based on screen size
        double topPosition = screenSize.height * 0.4;
        double leftPosition = screenSize.width * 0.2;
        double scale = 1.5;
        double fontSize = screenSize.width * 0.08; // Adjust font size based on screen width

        return Positioned(
          top: topPosition,
          left: leftPosition,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: _controller.value,
              child: Text(
                "Mystic Summon!",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );

    Overlay.of(context)?.insert(overlayEntry);
    _controller.forward();

    await Future.delayed(Duration(seconds: 1));
    _controller.reverse();
    overlayEntry.remove();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Summon Cards'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                // Display the currency image
                Image.asset(
                  'assets/currencies/GachapomCoin.png', 
                  height: 30, // Adjust the size of the currency image
                  width: 30,  // Adjust the size of the currency image
                ),
                SizedBox(width: 8), // Add spacing between the image and the text
                // Display the currency amount
                Text(
                  '${currencyProvider.currency}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Summon your cards!',
              style: TextStyle(fontSize: 18),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var count in [1, 5, 10, 50, 100])
                  StatefulBuilder(
                    builder: (context, setInnerState) {
                      bool isPressed = false;
                      return GestureDetector(
                        onTapDown: (_) {
                          setInnerState(() => isPressed = true);
                        },
                        onTapCancel: () {
                          setInnerState(() => isPressed = false);
                        },
                        onTapUp: (_) {
                          setInnerState(() => isPressed = false);
                          _performSummon(count, currencyProvider);
                        },
                        child: AnimatedScale(
                          duration: Duration(milliseconds: 200),
                          scale: isPressed ? 0.9 : 1.0,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/summongems/x$count.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'x$count',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    side: BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _performMysticSummon(currencyProvider),
                  child: Column(
                    children: [
                      Text(
                        'Mystic Summon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '(100,000 Currency)',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                side: BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryPage()),
                ).then((_) => _loadSummonedCards());
              },
              child: Text(
                'View Inventory',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                        crossAxisCount: 2,
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
        child: SingleChildScrollView( // To allow scrolling on smaller devices
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding for better spacing
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glow effect on the card image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.6),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(imagePath ?? 'assets/cardbackgrounds/default.png', width: 250, height: 400, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Card Rarity: $rarity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
