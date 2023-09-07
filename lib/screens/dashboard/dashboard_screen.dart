import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_feeder/constant.dart';
import 'package:smart_feeder/models/image_history_model.dart';
import 'package:smart_feeder/models/sensors_model.dart';
import 'package:smart_feeder/screens/dashboard/molecules/button.dart';
import 'package:smart_feeder/screens/dashboard/molecules/status_kandang_card.dart';
import 'package:smart_feeder/screens/dashboard/molecules/status_setting_card.dart';
import 'package:smart_feeder/screens/dashboard/providers/get_local_time_cubit.dart';
import 'package:smart_feeder/screens/dashboard/providers/get_servo_state.dart';
import 'package:smart_feeder/screens/dashboard/providers/realtime_sensor_cubit.dart';
import 'package:smart_feeder/screens/history/providers/image_history_cubit.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  DatabaseReference refServo = FirebaseDatabase.instance.ref('servo');
  DatabaseReference refCamera = FirebaseDatabase.instance.ref('camera');
  DatabaseReference servoFeedbackRef =
      FirebaseDatabase.instance.ref('servoFeedback');

  // late Map<String, dynamic> data;
  final statusCardDetail = [
    ['lib/icons/temp.png', 'Suhu'],
    ['lib/icons/water.png', 'Suhu'],
    ['lib/icons/bird_feeder.png', 'Pakan'],
  ];

  final listImage = [
    'https://images.pexels.com/photos/840111/pexels-photo-840111.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3399700/pexels-photo-3399700.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/195226/pexels-photo-195226.jpeg?auto=compress&cs=tinysrgb&w=800',
  ];

  @override
  Widget build(BuildContext context) {
    Future<void> feedNow() async {
      try {
        await refServo.set(1).whenComplete(() {
          servoFeedbackRef.set(false);
        });
      } catch (e) {
        log(e.toString());
      }
    }

    Future<void> captureNow() async {
      try {
        refCamera.set(1);
      } catch (e) {
        log(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.7),
      body: SafeArea(
        child: BlocBuilder<RealtimeSensorCubit, Sensors>(
          builder: (context, realtime) {
            int timestamp = realtime.time ?? 0;
            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            final lastUpdate = checkRelativeTime(timestamp);
            final isOnline = isDeviceOnline(dateTime);
            log(isOnline.toString());
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    BlocBuilder<DateTimeCubit, DateTime>(
                      builder: (context, dateTime) {
                        final jam = DateFormat.Hm().format(dateTime);
                        final message = checkTimeOfDay(jam);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat $message,',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  'Mutiara',
                                  style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      height: 1.3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Image.asset(
                              message == 'Malam'
                                  ? 'lib/icons/moon.png'
                                  : 'lib/icons/sun.png',
                              scale: 8,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    StatusSettingCard(
                      temp: realtime.temp,
                      hum: realtime.humidity,
                    ),
                    const SizedBox(height: 16),
                    StatusKandangCard(
                      isNotif: (realtime.feed ?? 0) <= 20 ? true : false,
                      temp: realtime.feedTemp,
                      feedAmount: realtime.feed,
                      lastUpdate: lastUpdate,
                      status: isOnline == true ? 'Online' : 'Offline',
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gambar',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: AppColors.grey80,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ImageHistoryCubit, List<ImageHistory>>(
                        builder: (contex, dataHistory) {
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ListView.builder(
                          itemCount:
                              dataHistory.length >= 3 ? 3 : dataHistory.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    dataHistory[index].time * 1000);
                            String formattedTime =
                                DateFormat("yyyy MMMM d, hh:mm a")
                                    .format(dateTime);
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

                            // log("dash ${base64String.length}");

                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
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
                                            backgroundColor: Colors
                                                .grey.shade100
                                                .withOpacity(0.43)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          BlocBuilder<GetServoState, int>(
                              builder: (context, servoState) {
                            return Button(
                              widget: (servoState == 0)
                                  ? Text('Feed Now')
                                  : CircularProgressIndicator(
                                      color: Colors.blue.shade300,
                                    ),
                              isOnline: isOnline,
                              onTap: feedNow,
                            );
                          }),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.grey.shade400,
                          ),
                          Button(
                            widget: Text('Capture Now'),
                            isOnline: isOnline,
                            onTap: captureNow,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

bool isDeviceOnline(DateTime dbTime) {
  DateTime currentDateTime = DateTime.now();
  int toleranceSeconds = 10;
  int timeDifference = currentDateTime.difference(dbTime).inSeconds.abs();
  if (timeDifference <= toleranceSeconds) {
    return true;
  } else {
    return false;
  }
}

String checkTimeOfDay(String formattedTime) {
  int hour = int.parse(formattedTime.split(':')[0]);

  if (hour >= 5 && hour < 12) {
    return 'Pagi';
  } else if (hour >= 12 && hour < 15) {
    return 'Siang';
  } else if (hour >= 15 && hour < 18) {
    return 'Sore';
  } else {
    return 'Malam';
  }
}

String checkRelativeTime(int timestamp) {
  DateTime now = DateTime.now();
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  int differenceInDays = now.difference(dateTime).inDays;

  if (differenceInDays == 0) {
    String formattedTime = DateFormat.Hm().format(dateTime);
    return 'Hari ini, $formattedTime';
  } else if (differenceInDays == 1) {
    return 'Kemarin';
  } else if (differenceInDays < 4) {
    String formattedTime = DateFormat('EEEE').format(dateTime);
    return formattedTime;
  } else {
    String formattedTime = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedTime;
  }
}
