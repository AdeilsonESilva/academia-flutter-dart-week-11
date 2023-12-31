import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/model/schedule_model.dart';

abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> scheduleCustomer(
      ({
        int barbershopId,
        int userId,
        String customerName,
        DateTime date,
        int time
      }) scheduleData);

  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
      ({
        DateTime date,
        int userId,
      }) filter);
}
