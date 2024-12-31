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
      create: (_) => CurrencyProvider()..loadCurrency(),
      child: MaterialApp(
        title: 'Gacha Clicker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.brown[100], // Light brown background
          appBarTheme: AppBarTheme(
            color: Colors.teal, // Teal app bar
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.brown[800]), // Brown text
            bodyMedium: TextStyle(color: Colors.teal[700]), // Teal accent text
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Teal buttons
              foregroundColor: Colors.white, // Button text
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
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
        title: Text('Gachove'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for settings page
              },
              child: Text('Settings'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for exit logic
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
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal[50], // Light teal background for text
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Currency: ${currencyProvider.currency}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
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
        ],
      ),
    );
  }
}
