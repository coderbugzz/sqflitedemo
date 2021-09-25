import 'package:intl/intl.dart';

class bill{
  final int? id;
  final String? Date;
  final double? LastReading;
  final double? kWH;
  final double? prevBill;
  final String? status;


  bill({
    this.id,
    this.Date,
    this.LastReading,
    this.kWH,
    this.prevBill,
    this.status
  }); 



  bill.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        Date = DateFormat("dd-MM-yyyy").format(DateTime.parse(res["Date"].toString())),
        LastReading = double.parse(res["LastReading"].toString()),
        kWH = double.parse(res["kWH"].toString()),
        prevBill = double.parse(res["prevBill"].toString()),
        status = res["status"];

  Map<String, Object?> toMap() {
    return {'id':id,'Date': Date, 'LastReading': LastReading, 'kWH': kWH, 'prevBill': prevBill,"status": status};
  }
}