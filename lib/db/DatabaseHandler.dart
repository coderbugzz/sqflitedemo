import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitedemo/Models/bill.dart';

class DatabaseHandler{

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'bill.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE bill(id INTEGER PRIMARY KEY AUTOINCREMENT, Date DateTime NOT NULL,LastReading DECIMAL(18,2) NOT NULL, kWH DECIMAL(18,2) NOT NULL, prevBill DECIMAL(18,2), status TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertBill(bill _bill) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('bill', _bill.toMap());
    
    return result;
  }
  
  Future<int> updateStatus() async {
    int result = 0;
    final Database db = await initializeDB();
    
      result = await db.rawUpdate("UPDATE bill SET status = 'InActive'");
    
    return result;
  }

  Future<List<bill>> retrieveBill() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('bill');

    return queryResult.map((e) => bill.fromMap(e)).toList();
  }

     Future<bill> activeBill() async {
     bill result = new bill(); 
    final Database db = await initializeDB();
     var queryResult = await db.rawQuery("Select * FROM bill where status = 'Active'");
     var data = queryResult.first;
      result = bill.fromMap(data);
    return result;
  }

  Future<void> deleteBill(int id) async {
    final db = await initializeDB();
    await db.delete(
      'bill',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}