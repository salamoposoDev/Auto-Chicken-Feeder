import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetServoState extends Cubit<int> {
  final DatabaseReference _dbRef;
  GetServoState()
      : _dbRef = FirebaseDatabase.instance.ref('servo'),
        super(0);

  void getData() {
    _dbRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        int state = event.snapshot.value as int;

        emit(state);
      }
    });
  }
}
