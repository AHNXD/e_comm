import 'package:flutter/material.dart';

class BarcodeSereen extends StatelessWidget {
  const BarcodeSereen({super.key, required this.resault});
  final String resault;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(resault),
      ),
    );
  }
}
