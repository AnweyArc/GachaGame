import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<String> summonedCards = [];

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
    });
  }

  // Save the summoned cards to SharedPreferences
  Future<void> _saveSummonedCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('summonedCards', summonedCards);
  }

  @override
  Widget build(BuildContext context) {
    // Group cards by rarity
    var groupedCards = groupBy(summonedCards, (String card) => card);

    // Sort the groups by the count in descending order
    var sortedGroupedCards = groupedCards.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: sortedGroupedCards.isEmpty
          ? Center(child: Text('No cards in inventory.'))
          : ListView.builder(
              itemCount: sortedGroupedCards.length,
              itemBuilder: (context, index) {
                var rarity = sortedGroupedCards[index].key;
                var count = sortedGroupedCards[index].value.length;
                return ListTile(
                  title: Text('$rarity x $count'),
                );
              },
            ),
    );
  }
}
