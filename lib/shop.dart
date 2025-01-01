import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart'; // Import the CurrencyProvider
import 'shopinfo.dart'; // Import the ShopInfo

class ShopPage extends StatelessWidget {
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
                return shopItem(item, currencyProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget shopItem(ShopItem item, CurrencyProvider currencyProvider) {
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
          ElevatedButton(
            onPressed: currencyProvider.currency >= item.itemPrice
                ? () {
                    currencyProvider.decreaseCurrency(item.itemPrice);
                    // Add functionality to "buy" the item here
                  }
                : null, // Disable the button if not enough currency
            child: Text('Buy'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Add equip functionality here
            },
            child: Text('Equip'),
          ),
        ],
      ),
    );
  }
}
