import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_feeder/models/sensors_model.dart';

class RealtimeSensorCubit extends Cubit<Sensors> {
  final DatabaseReference _databaseReference;

  RealtimeSensorCubit(String childPath)
      : _databaseReference = FirebaseDatabase.instance.ref(childPath),
        super(Sensors());

  void getData() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        String dataStr = jsonEncode(event.snapshot.value);

        var realtimeData = Sensors.fromJson(json.decode(dataStr));

        emit(realtimeData);
      }
    });
  }
}
