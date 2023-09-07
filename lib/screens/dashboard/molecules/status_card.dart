import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
  });
  final String icon;
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(
            icon,
            height: 40,
            color: Colors.blueGrey,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
