import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDs extends CalendarDataSource {
  @override
  List? get appointments => [
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: 'Adeilson Silva',
        ),
        Appointment(
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 4)),
          subject: 'Colab 1',
        ),
      ];
}
