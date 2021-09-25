import 'package:flutter/material.dart';
import 'package:sqflitedemo/Models/bill.dart';
import 'package:sqflitedemo/db/DatabaseHandler.dart';

class MyData extends DataTableSource {
DatabaseHandler handler;
List<bill> _bill;
MyData(this._bill, this.handler);


  bool get isRowCountApproximate => false;
  int get rowCount => _bill.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_bill[index].Date.toString())),
      DataCell(Text(_bill[index].LastReading.toString())),
      DataCell(Text(_bill[index].kWH.toString())),
      DataCell(Text(_bill[index].prevBill.toString())),
      DataCell(IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          var f = _bill[index].id.toString();
         handler.deleteBill(int.parse(_bill[index].id.toString()));
      
      },)),
    ]);
  }

List<DataRow> getRows(List<bill> users) => users.map((bill _bills) {
        final cells = [
          _bills.Date,
          _bills.LastReading,
          _bills.kWH,
          _bills.prevBill
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

}