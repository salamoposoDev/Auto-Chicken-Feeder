import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_feeder/models/schedule_model.dart';
import 'package:smart_feeder/screens/setting/molecules/mode_card.dart';
import 'package:smart_feeder/screens/setting/molecules/schedule_dialog.dart';
import 'package:smart_feeder/screens/setting/molecules/setting_card.dart';
import 'package:smart_feeder/screens/setting/providers/get_schedules_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final modeRef = FirebaseDatabase.instance.ref('mode');
  final scheduleRef = FirebaseDatabase.instance.ref('schedule');

  var isActive = false;
  bool? mode;

  Future<void> addSchedule(
      {String? index, String? time, String? amount}) async {
    if (index!.isNotEmpty && time!.isNotEmpty && amount!.isNotEmpty) {
      try {
        final key = index.toString();
        await scheduleRef.child(key).update({
          "time": time,
          "amount": amount,
          "state": true,
        }).whenComplete(() {
          FirebaseDatabase.instance.ref('restart').set(1);
          Navigator.pop(context);
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<dynamic> scheduleDialog({BuildContext? context, String? key}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return ScheduleDialog(
            onSave: (timeOfDay, value) {
              addSchedule(
                index: key,
                time: '${timeOfDay.hour}:${timeOfDay.minute}',
                amount: value,
              );
            },
          );
        });
  }

  Future<void> setMode(bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (value == true) {
        modeRef.set(true).whenComplete(() {
          prefs.setBool('mode', value);
          setState(() {
            isActive = value;
          });
        });
      } else {
        modeRef.set(false).whenComplete(() {
          prefs.setBool('mode', value);
          setState(() {
            isActive = value;
          });
        });
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('mode') != null) {
      bool storedData = prefs.getBool('mode') as bool;
      setState(() {
        isActive = storedData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ],
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
                          'Pemberian pakan otomatis akan dihentikan jika jumlah pakan pada penampungan habis.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pakan Ayam',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ModeCard(
                  isActive: isActive,
                  onChanged: (value) {
                    setMode(value);
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<GetSchedules, List<TimeSet>>(
                    builder: (context, schedule) {
                  final lastKey = schedule.length;
                  final time = <String>[];
                  final amount = <String>[];
                  for (var element in schedule) {
                    time.add(element.time);
                    amount.add(element.amount);
                  }

                  return SettingCard(
                    jam: time,
                    amount: amount,
                    onPressed: () {
                      scheduleDialog(
                          context: context, key: (lastKey + 1).toString());
                    },
                    onDelete: () {
                      scheduleRef
                          .child(lastKey.toString())
                          .remove()
                          .whenComplete(() {
                        setState(() {});
                        time.clear();
                        amount.clear();
                        schedule.clear();
                      });
                    },
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
