import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart'; // Import the CurrencyProvider
import 'shopinfo.dart'; // Import the ShopInfo
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  // TabController for tab navigation
  late TabController _tabController;
  late List<bool> ownedItems;
  late List<bool> equippedItems;

  @override
  void initState() {
    super.initState();
    _loadOwnedAndEquippedItems();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs: Equippables and Upgrades
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
      // Ensure only one AutoClicker is equipped at a time
      if (index == 0) {  // AutoClicker (index 0)
        equippedItems[1] = false; // Unequip Faster AutoClicker
      } else if (index == 1) {  // Faster AutoClicker (index 1)
        equippedItems[0] = false; // Unequip AutoClicker
      }
      
      equippedItems[index] = !equippedItems[index]; // Toggle equip state
      _saveEquippedItem(index, equippedItems[index]); // Save state to shared preferences

      // Handle starting or stopping the AutoClicker based on the equipped state
      if (equippedItems[index]) {
        currencyProvider.startAutoClicker(index == 0 ? 10 : 20); // 10 for AutoClicker, 20 for Faster AutoClicker
      } else {
        currencyProvider.stopAutoClicker(); // Stop AutoClicker when unequipped
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          // Display the current currency in the app bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Display the currency image
                Image.asset(
                  'assets/currencies/GachapomCoin.png', 
                  height: 30, // Adjust the size of the currency image
                  width: 30,  // Adjust the size of the currency image
                ),
                SizedBox(width: 8), // Add some spacing between the image and the text
                // Display the currency amount
                Text(
                  '${currencyProvider.currency}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Equippables'),
            Tab(text: 'Upgrades'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Equippables Tab
          ListView.builder(
            itemCount: ShopInfo.items.length,
            itemBuilder: (context, index) {
              final item = ShopInfo.items[index];
              // Only show equippables in this tab
              if (item.category == 'Equippable') {
                return shopItem(item, currencyProvider, index);
              }
              return SizedBox.shrink(); // Empty space for non-equippable items
            },
          ),
          // Upgrades Tab
          ListView.builder(
            itemCount: ShopInfo.items.length,
            itemBuilder: (context, index) {
              final item = ShopInfo.items[index];
              // Only show upgrades in this tab
              if (item.category == 'Upgrade') {
                return upgradeItem(item, currencyProvider, index);
              }
              return SizedBox.shrink(); // Empty space for non-upgrade items
            },
          ),
        ],
      ),
    );
  }

  // Widget for displaying equippable items
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
                      _toggleAutoClicker(index); // Toggle equip state for AutoClickers
                    });
                  }
                : null, // Disable button if not owned
            child: Text(equippedItems[index] ? 'Equipped' : 'Equip'),
          ),
        ],
      ),
    );
  }

  // Widget for displaying upgrade items (with "Buy" option only)
  Widget upgradeItem(ShopItem item, CurrencyProvider currencyProvider, int index) {
    return ListTile(
      title: Text(item.itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \$${item.itemPrice}'),
          Text('Description: ${item.itemDescription}'),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: currencyProvider.currency >= item.itemPrice &&
                !ownedItems[index]
            ? () {
                // Buy the upgrade item
                currencyProvider.decreaseCurrency(item.itemPrice);
                setState(() {
                  ownedItems[index] = true; // Mark item as owned
                });
                _saveOwnedItem(index, true); // Save state to shared preferences
              }
            : null, // Disable button if not enough currency or already owned
        child: Text(ownedItems[index] ? 'Owned' : 'Buy'),
      ),
    );
  }
}
