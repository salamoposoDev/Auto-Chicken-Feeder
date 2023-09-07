// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

import 'dart:convert';

class TimeSet {
  final String amount;
  final String time;
  final bool state;

  TimeSet({required this.amount, required this.time, required this.state});

  factory TimeSet.fromRawJson(String str) => TimeSet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeSet.fromJson(Map<String, dynamic> json) => TimeSet(
        amount: json["amount"],
        time: json["time"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "time": time,
        "state": state,
      };
}
