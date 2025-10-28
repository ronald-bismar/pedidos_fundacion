// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/asistencia_mensual/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/encargado/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/foto/local_datasource.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/local_datasources.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/ayuda_economica/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/beneficio/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/entrega_beneficiario/local_datasource.dart';
import 'package:pedidos_fundacion/features/entregas/data/datasources/producto_beneficiario/local_datasource.dart';
import 'package:sqflite/sqflite.dart';

// Provider para la dependencia DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

class DatabaseHelper {
  static const String databaseName = 'Fundacion.db';
  static const int databaseVersion = 1;
  Future<Database> openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: databaseVersion,
      onCreate: (db, version) async {
        await db.execute(CoordinatorLocalDataSource.coordinators);
        await db.execute(BeneficiaryLocalDataSource.beneficiaries);
        await db.execute(PhotoLocalDataSource.photos);
        await db.execute(GroupLocalDataSource.groups);
        await db.execute(AttendanceLocalDataSource.attendance);
        await db.execute(
          AttendanceBeneficiaryLocalDataSource.attendanceBeneficiary,
        );
        await db.execute(MonthlyAttendanceLocalDataSource.monthlyAttendance);
        await db.execute(FinancialAidLocalDataSource.financialAid);
        await db.execute(BenefitLocalDataSource.benefits);
        await db.execute(DeliveryLocalDataSource.delivery);
        await db.execute(
          DeliveryBeneficiaryLocalDataSource.deliveryBeneficiary,
        );
        await db.execute(ProductBeneficiaryLocalDataSource.productBeneficiary);
      },
    );
  }
}
