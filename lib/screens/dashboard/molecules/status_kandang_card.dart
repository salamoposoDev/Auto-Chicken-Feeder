import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_feeder/constant.dart';

class StatusKandangCard extends StatelessWidget {
  const StatusKandangCard({
    super.key,
    this.isNotif = false,
    this.temp,
    this.feedAmount,
    this.status = 'offline',
    this.lastUpdate,
  });
  final bool? isNotif;
  final int? temp;
  final int? feedAmount;
  final String? status;
  final String? lastUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(10, 10),
            color: Colors.grey.shade200,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'lib/icons/chicken.png',
                          scale: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Update terbaru',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey80),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Suhu Pakan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.grey80,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '${temp ?? 0} °C',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(
                        indent: 5,
                        endIndent: 10,
                        thickness: 2,
                      ),
                      Column(
                        children: [
                          Text(
                            'Jumlah Pakan',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.grey80,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '${feedAmount ?? 0} %',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: AppColors.grey80,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status Perangkat',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      status ?? 'Offline',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: status == 'Online' ? Colors.blue : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update Terakhir',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      lastUpdate ?? '00:00',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (isNotif == true) notification(text(feedAmount: feedAmount)),
        ],
      ),
    );
  }

  Container notification(String? text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text ?? '',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.red,
                fontWeight: FontWeight.w300,
                height: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String text({int? feedAmount}) {
  String? message;
  switch (feedAmount) {
    case 20:
      message =
          'Pakan hampir habis, segera lalukan pengisian ulang agar ternak makan tepat waktu!';
      break;
    case 0:
      message =
          'Pakan habis, lalukan pengisian ulang Sekarang agar ternak tidak telat makan!';
      break;
    default:
      message = '';
  }
  return message;
}
