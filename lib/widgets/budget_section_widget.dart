import 'package:flutter/material.dart';

class BudgetSectionWidget extends StatelessWidget {
  const BudgetSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Budget Tracking", style: TextStyle(color: Color(0xff2E5077))),
            TextButton(
              onPressed: () {},
              child: const Text("Manage", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),

      Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      kategori,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Rp. ${currentValue.toStringAsFixed(0)}K / ${targetValue.toStringAsFixed(0)}K",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
