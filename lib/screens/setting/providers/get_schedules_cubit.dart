import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeder/models/schedule_model.dart';

class GetSchedules extends Cubit<List<TimeSet>> {
  final DatabaseReference _databaseReference;

  GetSchedules()
      : _databaseReference = FirebaseDatabase.instance.ref('schedule'),
        super([]);

  Future<void> getData() async {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        final dataList = [];
        final keyList = event.snapshot.value.toString();
        for (var element in event.snapshot.children.toList()) {
          dataList.add(element.value);
        }
        final jsonString = jsonEncode(dataList);
        final jsonData = jsonDecode(jsonString);
        List<TimeSet> scheduleList = (jsonData as List)
            .map((itemWord) => TimeSet.fromJson(itemWord))
            .toList();
        log(keyList);
        emit(scheduleList);
        // scheduleList.clear();
      }
    });
  }
}
