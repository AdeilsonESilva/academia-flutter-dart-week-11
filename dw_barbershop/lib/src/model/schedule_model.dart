class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String customerName;
  final DateTime date;
  final int hour;

  ScheduleModel({
    required this.id,
    required this.barbershopId,
    required this.userId,
    required this.customerName,
    required this.date,
    required this.hour,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> json) {
    // TODO interesting
    switch (json) {
      case {
          'id': int id,
          'barbershop_id': int barbershopId,
          'user_id': int userId,
          'customer_name': String customerName,
          'date': String scheduleDate,
          'time': int hour,
        }:
        return ScheduleModel(
          id: id,
          barbershopId: barbershopId,
          userId: userId,
          customerName: customerName,
          date: DateTime.parse(scheduleDate),
          hour: hour,
        );
      case _:
        throw ArgumentError('Invalid JSON');
    }
  }
}
