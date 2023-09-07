import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_feeder/models/image_history_model.dart';
import 'package:smart_feeder/models/sensors_model.dart';
import 'package:smart_feeder/screens/history/detail_sensors_screen.dart';
import 'package:smart_feeder/screens/history/providers/image_history_cubit.dart';
import 'package:smart_feeder/screens/history/providers/sensor_list_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Semua data sensor dan gambar direkam disini, anda dapat mmelalukan sortir sesuai kebutuhan.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sensors',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<SensorsHistoryCubit, List<Sensors>>(
                    builder: (context, data) {
                  if (data.isEmpty) {
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                  return AverageHistoryCard(
                    temp: data.last.temp.toString(),
                    hum: data.last.humidity.toString(),
                    feedTemp: data.last.feedTemp.toString(),
                    feedAmount: data.last.feed.toString(),
                  );
                }),
                const SizedBox(height: 20),
                Text(
                  'Kamera',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ImageHistoryCubit, List<ImageHistory>>(
                    builder: (contex, dataHistory) {
                  return ListView.builder(
                    itemCount: dataHistory.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                          dataHistory[index].time * 1000);
                      String formattedTime =
                          DateFormat("yyyy MMMM d, hh:mm a").format(dateTime);
                      final base64String = <String>[];
                      for (var i = 0; i < dataHistory.length; i++) {
                        String cleanedBase64String = dataHistory[i]
                            .image
                            .replaceAll(
                                RegExp('data:image\\/[^;]+;base64,'), '');
                        cleanedBase64String =
                            cleanedBase64String.replaceAll('%2F', '/');
                        cleanedBase64String =
                            cleanedBase64String.replaceAll('%2B', '+');
                        cleanedBase64String =
                            cleanedBase64String.split(',').last;
                        base64String.add(cleanedBase64String);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                  base64Decode(base64String[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formattedTime,
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: Colors.black,
                                      backgroundColor: Colors.grey.shade100
                                          .withOpacity(0.43)),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AverageHistoryCard extends StatelessWidget {
  const AverageHistoryCard({
    super.key,
    this.temp,
    this.hum,
    this.feedTemp,
    this.feedAmount,
  });
  final String? temp;
  final String? hum;
  final String? feedTemp;
  final String? feedAmount;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.orange.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hari ini',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    )),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailSensorsScreen())),
                  child: Row(
                    children: [
                      Text(
                        'Lebih',
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.blue),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suhu kandang',
                      style: GoogleFonts.roboto(),
                    ),
                    Text(
                      '${temp ?? ''} °C',
                      style: GoogleFonts.roboto(),
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kelembapan kandang',
                      style: GoogleFonts.roboto(),
                    ),
                    Text(
                      '${hum ?? ' '} %',
                      style: GoogleFonts.roboto(),
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suhu pakan',
                      style: GoogleFonts.roboto(),
                    ),
                    Text(
                      '${feedTemp ?? ''} °C',
                      style: GoogleFonts.roboto(),
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah pakan',
                      style: GoogleFonts.roboto(),
                    ),
                    Text(
                      '${feedAmount ?? ''} %',
                      style: GoogleFonts.roboto(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
