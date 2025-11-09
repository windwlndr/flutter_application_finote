import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onSearchTap,
    this.onNotificationTap,
    this.backgroundColor = const Color(0xff2F59AB),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  // Wajib override ini agar bisa dipakai di Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
