import 'package:flutter/material.dart';

class CopyrightFooter extends StatelessWidget {
  final String text;

  const CopyrightFooter({
    super.key,
    this.text = "© 2025 Finote. Created by Windu Wulandari.",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
