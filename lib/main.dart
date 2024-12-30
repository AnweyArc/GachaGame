import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'summonpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyProvider()..loadCurrency(), // Load currency on start
      child: MaterialApp(
        title: 'Gacha Clicker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainMenu(),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage()),
                );
              },
              child: Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to settings (placeholder for now)
              },
              child: Text('Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                // Exit the app
                // Note: Exiting apps programmatically is discouraged in Flutter.
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

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
            child: Text(
              'Currency: ${currencyProvider.currency}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'Luck: 0', // You can update luck logic here if necessary
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                currencyProvider.increaseCurrency(1); // Example for currency generation
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
        ],
      ),
    );
  }
}
