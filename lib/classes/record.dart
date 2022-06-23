import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class SRecord {
  SRecord({required this.amount, required this.typeName, required this.dateTime, this.remark});

  @HiveField(0)
  String? remark;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String typeName;

  @HiveField(3)
  DateTime dateTime;
}
