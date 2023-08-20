import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/model/schedule_model.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({
    required this.schedules,
  });

  @override
  List? get appointments => schedules.map((e) {
        final ScheduleModel(
          date: DateTime(:year, :month, :day),
          :hour,
          :customerName
        ) = e;
        final startTime = DateTime(year, month, day, hour, 0, 0);
        final endTime = DateTime(year, month, day, hour + 1, 0, 0);

        return Appointment(
          color: ColorsConstants.brow,
          startTime: startTime,
          endTime: endTime,
          subject: customerName,
        );
      }).toList();
  /* [
        Appointment(
          color: ColorsConstants.brow,
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: 'Adeilson Silva',
        ),
        Appointment(
          color: ColorsConstants.brow,
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 4)),
          subject: 'Colab 1',
        ),
      ]; */
}
