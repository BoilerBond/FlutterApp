import 'package:flutter/material.dart';

class BondScreen extends StatefulWidget {
  const BondScreen({super.key});

  @override
  State<BondScreen> createState() => _BondScreenState();
}

class _BondScreenState extends State<BondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Bond Screen'),
      ),
    );
  }
}
