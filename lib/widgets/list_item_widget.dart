// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final IconData itemIcon;
  final String itemName;
  final String itemPrice;
  final String itemDateTime;
  final Color? priceColor;
  final Color? itemIconColor;

  const ListItemWidget({
    super.key,
    required this.itemIcon,
    required this.itemName,
    required this.itemPrice,
    required this.itemDateTime,
    this.priceColor,
    this.itemIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff9ECAD6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(itemIcon, color: itemIconColor ?? Color(0xff2E5077)),
        title: Text(
          itemName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff2E5077),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              itemPrice,
              style: TextStyle(
                fontSize: 14,
                color: priceColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
            Text(
              itemDateTime,
              style: TextStyle(fontSize: 12, color: Color(0xff2E5077)),
            ),
          ],
        ),
      ),
    );
  }
}
