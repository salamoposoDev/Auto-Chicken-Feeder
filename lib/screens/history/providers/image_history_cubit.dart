import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeder/models/image_history_model.dart';

class ImageHistoryCubit extends Cubit<List<ImageHistory>> {
  DatabaseReference databaseReference;

  ImageHistoryCubit()
      : databaseReference = FirebaseDatabase.instance.ref('history/images'),
        super([]);

  void getData() {
    final imagelist = [];
    final refImages = FirebaseDatabase.instance.ref('history/images');
    refImages.onValue.listen((event) {
      if (event.snapshot.exists) {
        for (var element in event.snapshot.children) {
          imagelist.add(element.value);
          // log(imagelist.length.toString());
        }
        final jsonString = jsonEncode(imagelist);
        final jsonData = jsonDecode(jsonString);
        List<ImageHistory> history = (jsonData as List)
            .map((itemWord) => ImageHistory.fromJson(itemWord))
            .toList();
        emit(history.reversed.toList());
        // log("history = ${history.length}");
        imagelist.clear();
      }
    });
  }
}
