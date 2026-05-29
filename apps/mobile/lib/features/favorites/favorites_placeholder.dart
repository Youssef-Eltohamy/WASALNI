import 'package:flutter/material.dart';

class FavoritesPlaceholder extends StatelessWidget {
  const FavoritesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('المفضلة — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
