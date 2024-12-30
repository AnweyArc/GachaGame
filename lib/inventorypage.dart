import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Import collection package to group cards
import 'package:provider/provider.dart';


class InventoryPage extends StatelessWidget {
  final List<String> summonedCards;

  InventoryPage({required this.summonedCards});

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
