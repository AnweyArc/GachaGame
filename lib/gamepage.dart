import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'summonpage.dart'; // Import the summon page
import 'shop.dart'; // Import the shop page

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Page'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal[50], // Light teal background for the text container
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Display the currency image
                  Image.asset(
                    'assets/currencies/GachapomCoin.png', 
                    height: 30, // Adjust the size of the currency image
                    width: 30,  // Adjust the size of the currency image
                  ),
                  SizedBox(width: 8),
                  // Display the currency amount
                  Text(
                    '${currencyProvider.currency}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Luck: 0', // Update with actual logic if needed
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final equippedCard = currencyProvider.equippedCard;
                final multiplier = equippedCard?.currencyMultiplier ?? 1;
                currencyProvider.increaseCurrency(1 * multiplier);
              },
              child: Text('Click to Generate Currency'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummonPage(),
                  ),
                );
              },
              child: Text('Summon'),
            ),
          ),
          // Shop button at the bottom-right
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopPage(), // Navigate to the ShopPage
                  ),
                );
              },
              child: Text('Shop'),
            ),
          ),
        ],
      ),
    );
  }
}
