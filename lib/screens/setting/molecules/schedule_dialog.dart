import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleDialog extends StatefulWidget {
  const ScheduleDialog({
    super.key,
    required this.onSave,
  });
  final void Function(TimeOfDay timeOfDay, String selectedAmount) onSave;

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedValue = '';
  @override
  Widget build(BuildContext context) {
    log(selectedTime.toString());
    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Tambah jadwal',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey.shade900),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onSave(selectedTime, selectedValue);
          },
          child: Text(
            'Save',
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
            Colors.grey,
          )),
          child: Text(
            'Cancel',
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'waktu',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.grey.shade900),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final timeSelect = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (timeSelect != null) {
                          setState(() {
                            selectedTime = timeSelect;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${selectedTime.hour}: ${selectedTime.minute}',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    'Jumlah',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.grey.shade900),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton(
                      iconEnabledColor: Colors.blue,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(12),
                      hint: Text(selectedValue.isEmpty
                          ? 'Pilih'
                          : '${selectedValue} gr'),
                      items: const [
                        DropdownMenuItem(
                          child: Text('300 gram'),
                          value: '300',
                        ),
                        DropdownMenuItem(
                          child: Text('600 gram'),
                          value: '600',
                        ),
                        DropdownMenuItem(
                          child: Text('1000 gram'),
                          value: '1000',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
