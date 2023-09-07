import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_feeder/models/sensors_model.dart';
import 'package:smart_feeder/screens/history/providers/sensor_list_cubit.dart';

class DetailSensorsScreen extends StatelessWidget {
  const DetailSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SensorsHistoryCubit>(
            create: (context) => SensorsHistoryCubit()..getData()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Detail',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: BlocBuilder<SensorsHistoryCubit, List<Sensors>>(
              builder: (context, data) {
                if (data.isEmpty) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  final reversedData = data.reversed.toList();
                  return Column(
                    children: [
                      ListView.builder(
                        itemCount: reversedData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          DateTime dateTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  reversedData[index].time! * 1000);
                          String formattedDateTime =
                              DateFormat('yyyy MMMM dd, HH:mm')
                                  .format(dateTime);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DetailSensorCard(
                              temp: reversedData[index].temp,
                              hum: reversedData[index].humidity,
                              feedAmount: reversedData[index].feed,
                              feedTemp: reversedData[index].feedTemp,
                              time: formattedDateTime.toString(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        )),
      ),
    );
  }
}

class DetailSensorCard extends StatelessWidget {
  const DetailSensorCard({
    super.key,
    this.temp,
    this.hum,
    this.feedTemp,
    this.feedAmount,
    this.time,
  });
  final int? temp;
  final int? hum;
  final int? feedTemp;
  final int? feedAmount;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time.toString(),
                style: GoogleFonts.roboto(
                    color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suhu kandang',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '$temp °C',
                style: GoogleFonts.roboto(),
              ),
            ],
          ),
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kelembapan kandang',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '$hum %',
                style: GoogleFonts.roboto(),
              ),
            ],
          ),
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suhu pakan',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '$feedTemp °C',
                style: GoogleFonts.roboto(),
              ),
            ],
          ),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jumlah pakan',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '$feedAmount %',
                style: GoogleFonts.roboto(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
