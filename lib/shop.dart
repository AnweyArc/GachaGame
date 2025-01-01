import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart'; // Import the CurrencyProvider
import 'shopinfo.dart'; // Import the ShopInfo
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // List to keep track of owned items
  late List<bool> ownedItems;
  // List to keep track of equipped items
  late List<bool> equippedItems;

  @override
  void initState() {
    super.initState();
    _loadOwnedAndEquippedItems();
  }

  // Load the state of owned and equipped items from shared preferences
  _loadOwnedAndEquippedItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<bool> owned = List.generate(ShopInfo.items.length, (index) {
      return prefs.getBool('item_${index}_owned') ?? false; // Default to false if not set
    });
    List<bool> equipped = List.generate(ShopInfo.items.length, (index) {
      return prefs.getBool('item_${index}_equipped') ?? false; // Default to false if not set
    });

    setState(() {
      ownedItems = owned;
      equippedItems = equipped;
      // If AutoClicker is equipped, start its effect
      if (equippedItems[0]) {
        Provider.of<CurrencyProvider>(context, listen: false).startAutoClicker(10); // Start AutoClicker with 10 currency per second
      }
    });
  }

  // Save the state of owned items
  _saveOwnedItem(int index, bool isOwned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('item_${index}_owned', isOwned);
  }

  // Save the state of equipped items
  _saveEquippedItem(int index, bool isEquipped) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('item_${index}_equipped', isEquipped);
  }

  // Function to start or stop the AutoClicker when equipped
  _toggleAutoClicker(int index) {
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
    setState(() {
      if (equippedItems[index]) {
        // Start AutoClicker if it's equipped
        currencyProvider.startAutoClicker(10); // Adjust the increment as per your need
      } else {
        // Stop AutoClicker if it's not equipped
        currencyProvider.stopAutoClicker();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Column(
        children: [
          // Display current currency at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current Currency: ${currencyProvider.currency}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // List of items in the shop
          Expanded(
            child: ListView.builder(
              itemCount: ShopInfo.items.length, // Fetch item count from ShopInfo
              itemBuilder: (context, index) {
                final item = ShopInfo.items[index];
                return shopItem(item, currencyProvider, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget shopItem(ShopItem item, CurrencyProvider currencyProvider, int index) {
    return ListTile(
      title: Text(item.itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \$${item.itemPrice}'),
          Text('Description: ${item.itemDescription}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Buy button
          ElevatedButton(
            onPressed: currencyProvider.currency >= item.itemPrice &&
                    !ownedItems[index]
                ? () {
                    // Buy the item
                    currencyProvider.decreaseCurrency(item.itemPrice);
                    setState(() {
                      ownedItems[index] = true; // Mark item as owned
                    });
                    _saveOwnedItem(index, true); // Save state to shared preferences
                  }
                : null, // Disable button if not enough currency or already owned
            child: Text(ownedItems[index] ? 'Owned' : 'Buy'),
          ),
          SizedBox(width: 10),
          // Equip/Unequip button
          ElevatedButton(
            onPressed: ownedItems[index]
                ? () {
                    setState(() {
                      equippedItems[index] = !equippedItems[index]; // Toggle equip state
                      _toggleAutoClicker(index); // Start/Stop AutoClicker
                    });
                    _saveEquippedItem(index, equippedItems[index]); // Save state to shared preferences
                  }
                : null, // Disable button if not owned
            child: Text(equippedItems[index] ? 'Equipped' : 'Equip'),
          ),
        ],
      ),
    );
  }
}
