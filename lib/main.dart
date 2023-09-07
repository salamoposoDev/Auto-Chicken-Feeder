import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_feeder/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeder/screens/dashboard/providers/get_local_time_cubit.dart';
import 'package:smart_feeder/screens/dashboard/providers/get_servo_state.dart';
import 'package:smart_feeder/screens/dashboard/providers/get_timestamp_cubit.dart';
import 'package:smart_feeder/screens/dashboard/providers/realtime_sensor_cubit.dart';
import 'package:smart_feeder/screens/history/providers/image_history_cubit.dart';
import 'package:smart_feeder/screens/history/providers/sensor_list_cubit.dart';
import 'package:smart_feeder/screens/setting/providers/get_schedules_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RealtimeSensorCubit>(
            create: (context) => RealtimeSensorCubit('sensors')..getData(),
          ),
          BlocProvider<DateTimeCubit>(create: (context) => DateTimeCubit()),
          BlocProvider<GetSchedules>(
              create: (context) => GetSchedules()..getData()),
          BlocProvider<ImageHistoryCubit>(
              create: (context) => ImageHistoryCubit()..getData()),
          BlocProvider<SensorsHistoryCubit>(
              create: (context) => SensorsHistoryCubit()..getData()),
          BlocProvider<GetServoState>(
              create: (context) => GetServoState()..getData()),
        ],
        child: HomePage(),
      ),
    );
  }
}
