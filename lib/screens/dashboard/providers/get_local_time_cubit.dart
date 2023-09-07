import 'package:flutter_bloc/flutter_bloc.dart';

class DateTimeCubit extends Cubit<DateTime> {
  DateTimeCubit() : super(DateTime.now());

  void getDateTime() {
    DateTime currentDateTime = DateTime.now();
    emit(currentDateTime);
  }
}
