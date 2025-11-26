import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.backgroundColor = const Color(0xff2F59AB),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,

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
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  //gar bisa dipakai di Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
