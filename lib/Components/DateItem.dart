import 'package:flutter/material.dart';

class DateItem extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;

  const DateItem({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFFFF6B6B) : const Color(0xFF2C2C2E),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF6B6B), width: 2)
                : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: Center(
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
