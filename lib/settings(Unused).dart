import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider(Unused).dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Color? selectedPrimaryColor;
    Color? selectedAccentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize Theme',
              style: Theme.of(context).textTheme.titleLarge, // Updated from headline6
            ),
            SizedBox(height: 20),
            Text('Select Primary Color:'),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _colorCircle(Colors.teal, () {
                  selectedPrimaryColor = Colors.teal;
                }),
                _colorCircle(Colors.brown, () {
                  selectedPrimaryColor = Colors.brown;
                }),
                _colorCircle(Colors.blue, () {
                  selectedPrimaryColor = Colors.blue;
                }),
                _colorCircle(Colors.red, () {
                  selectedPrimaryColor = Colors.red;
                }),
              ],
            ),
            SizedBox(height: 20),
            Text('Select Accent Color:'),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _colorCircle(Colors.tealAccent, () {
                  selectedAccentColor = Colors.tealAccent;
                }),
                _colorCircle(Colors.brown[200]!, () {
                  selectedAccentColor = Colors.brown[200]!;
                }),
                _colorCircle(Colors.blueAccent, () {
                  selectedAccentColor = Colors.blueAccent;
                }),
                _colorCircle(Colors.redAccent, () {
                  selectedAccentColor = Colors.redAccent;
                }),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedPrimaryColor != null &&
                      selectedAccentColor != null) {
                    themeProvider.updateTheme(
                      selectedPrimaryColor!,
                      selectedAccentColor!,
                    );
                  }
                },
                child: Text('Apply Theme'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorCircle(Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
