import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('وصلني')),
        body: const Center(child: Text('الرئيسية', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
