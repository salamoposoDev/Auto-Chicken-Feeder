import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusSettingCard extends StatelessWidget {
  const StatusSettingCard({
    super.key,
    this.temp,
    this.hum,
  });
  final int? temp;
  final int? hum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(10, 10),
            color: Colors.grey.shade300,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AnimatedTextKit(
                //   repeatForever: true,
                //   animatedTexts: [
                //     RotateAnimatedText(
                //       'Suhu | ${temp ?? 0} °C',
                //       textStyle:
                //           TextStyle(fontSize: 20.0, fontFamily: 'Canterbury'),
                //     ),
                //     RotateAnimatedText(
                //       'Suhu | ${temp ?? 0} °C',
                //       textStyle:
                //           TextStyle(fontSize: 20.0, fontFamily: 'Canterbury'),
                //     ),
                //   ],
                // ),
                // Text(
                //   'Suhu | ${temp ?? 0} °C',
                //   style: GoogleFonts.poppins(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.grey.shade800),
                // ),
                Text(
                  'Jaga selalu ketersediaan pakan!',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pada Mode Otomatis, pakan akan diberikan sesuai jadwal yang diatur',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      'lib/icons/temp.png',
                      scale: 4,
                      color: Colors.red,
                    ),
                    Text(
                      '${temp ?? 0} °C',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Image.asset(
                      'lib/icons/water.png',
                      scale: 2.7,
                      color: Colors.blue,
                    ),
                    Text(
                      '${hum ?? 0} %',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            'lib/icons/water-temperature.png',
            scale: 7,
          ),
        ],
      ),
    );
  }
}
