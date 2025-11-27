// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchTap;
  final Color backgroundColor;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onSearchTap,
    this.backgroundColor = const Color(0xff2F59AB),
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: backgroundColor,
      actions: [
        IconButton(
          onPressed: onSearchTap,
          icon: const Icon(Icons.search, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  //gar bisa dipakai di Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
