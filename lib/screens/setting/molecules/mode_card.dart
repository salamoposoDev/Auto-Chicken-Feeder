import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModeCard extends StatefulWidget {
  const ModeCard({
    super.key,
    this.onChanged,
    this.isActive = false,
  });
  final Function(bool)? onChanged;
  final bool? isActive;

  @override
  State<ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Mode Pemberian \nPakan',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.grey.shade600),
            ),
          ),
          Column(
            children: [
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                    activeColor: Colors.blue.shade300,
                    value: widget.isActive!,
                    onChanged: widget.onChanged),
              ),
              Text(
                widget.isActive! ? 'Auto' : 'Manual',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w200, fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
