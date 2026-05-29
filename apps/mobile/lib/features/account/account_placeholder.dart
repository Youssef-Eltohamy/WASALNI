import 'package:flutter/material.dart';

class AccountPlaceholder extends StatelessWidget {
  const AccountPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('حسابي — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
