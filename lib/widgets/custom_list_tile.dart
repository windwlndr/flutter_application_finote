// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.textColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      leading: Icon(leadingIcon, color: iconColor ?? Color(0xff2E5077)),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Color(0xff2E5077),
          decoration: TextDecoration.underline,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor ?? Color(0xff2E5077)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
      ),
      onTap: () {
        print("berhasil");
      },
    );
  }
}
