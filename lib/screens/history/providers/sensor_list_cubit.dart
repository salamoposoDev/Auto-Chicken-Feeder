import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeder/models/sensors_model.dart';

class SensorsHistoryCubit extends Cubit<List<Sensors>> {
  DatabaseReference ref;
  StreamSubscription? _subscription;

  SensorsHistoryCubit()
      : ref = FirebaseDatabase.instance.ref(),
        super([]) {
    getData();
  }

  void getData() async {
    final snapshot = await ref.child('history/sensors').get();
    if (snapshot.exists) {
      final data = [];
      for (var element in snapshot.children) {
        data.add(element.value);
      }
      final jsonData = jsonEncode(data);
      final jsonMap = json.decode(jsonData);
      List<Sensors> dataSensors = (jsonMap as List)
          .map((itemWord) => Sensors.fromJson(itemWord))
          .toList();
      emit(dataSensors);
      data.clear();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
