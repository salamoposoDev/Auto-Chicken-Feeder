import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTimestamp extends Cubit<DateTime> {
  final DatabaseReference _dbRef;
  GetTimestamp()
      : _dbRef = FirebaseDatabase.instance.ref('timestamp'),
        super(DateTime.now());

  void getData() {
    _dbRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        int timestamp = event.snapshot.value as int;
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

        emit(dateTime);
      }
    });
  }
}
