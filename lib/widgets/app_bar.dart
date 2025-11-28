// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final Widget? searchField;
  final VoidCallback? onSearchTap;
  final Color backgroundColor;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isSearching = false,
    this.searchField,
    this.onSearchTap,
    this.backgroundColor = const Color(0xff2F59AB),
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      backgroundColor: backgroundColor,
      title: isSearching
          ? searchField
          : Text(title, style: const TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          onPressed: onSearchTap,
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
