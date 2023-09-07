import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingCard extends StatefulWidget {
  const SettingCard({
    super.key,
    required this.jam,
    required this.amount,
    required this.onPressed,
    this.onDelete,
  });
  final List<String> jam;
  final List<String> amount;

  final VoidCallback onPressed;
  final VoidCallback? onDelete;

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  int currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Schedule',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey.shade900),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(6, 6),
                  elevation: 1,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          if (widget.jam.isNotEmpty)
            ListView.builder(
              itemCount: widget.jam.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ScheduleForm(
                  amount: widget.amount[index],
                  time: widget.jam[index],
                  text: index + 1,
                  onDelete: widget.onDelete,
                );
              },
            ),
          // if (isFull == true) const Text('Scedule Hanya Bisa 3!!'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ScheduleForm extends StatelessWidget {
  const ScheduleForm({
    super.key,
    required this.time,
    required this.amount,
    this.text,
    this.onDelete,
  });
  final String time;
  final String amount;
  final VoidCallback? onDelete;
  final int? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time $text',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey.shade700),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                    child: Text(
                  time,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey.shade800),
                )),
              )
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey.shade700),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                          child: Text(
                        amount,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey.shade800),
                      )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
