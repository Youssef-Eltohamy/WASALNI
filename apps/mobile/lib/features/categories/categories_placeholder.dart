import 'package:flutter/material.dart';

class CategoriesPlaceholder extends StatelessWidget {
  const CategoriesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('التصنيفات — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
