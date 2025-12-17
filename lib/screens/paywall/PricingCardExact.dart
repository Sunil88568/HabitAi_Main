import 'package:flutter/material.dart';

class PricingCardExact extends StatelessWidget {
  final String title;
  final String tagText;
  final Color tagColor;
  final String description;
  final String price;
  final String oldPrice;
  final String? note;
  final Color background;
  final Color border;

  const PricingCardExact({
    super.key,
    required this.title,
    required this.tagText,
    required this.tagColor,
    required this.description,
    required this.price,
    required this.oldPrice,
    this.note,
    required this.background,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Title + Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: -0.24, // -1% of 24px (valid)
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  height: 1.5,
                  letterSpacing: -0.24, // -1% of 24px (valid)
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // --- Description background: ;
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 160, 138, 11).withOpacity(0.55),
            ),
          ),

          const SizedBox(height: 12),

          // --- Price Row
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF95D7F2),

                ),
              ),
            ],
          ),

          if (note != null) ...[
            const SizedBox(height: 6),
            Text(
              note!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
