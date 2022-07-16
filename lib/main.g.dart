import 'package:hive/hive.dart';



@HiveType(typeId: 0)
class Dater extends HiveObject {
  @HiveField(0)
  String longg;
  @HiveField(1)
  String latt;
  @HiveField(2)
  String altt;
  @HiveField(3)
  int indexer;

  Dater({this.longg,this.latt, this.altt,this.indexer});
}