import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;



  const BottomNavItem({super.key, required this.icon, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: isSelected ? const Color(0xFF5A5CE6) : Colors.grey, size: 24),
    );
  }
}
