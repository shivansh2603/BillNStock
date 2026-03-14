import 'package:flutter/material.dart';

class UnitToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const UnitToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2196F3);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? primaryBlue.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? primaryBlue : const Color(0xFFE3F2FD),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? primaryBlue : Colors.black87,
          ),
        ),
      ),
    );
  }
}
