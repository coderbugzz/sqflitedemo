import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflitedemo/DataSource/datasource.dart';
import 'package:sqflitedemo/Models/bill.dart';
import 'package:sqflitedemo/db/DatabaseHandler.dart';


class DemoPage extends StatefulWidget{
 
   @override
  State<StatefulWidget> createState() {
    return _DemoPage();
  }
}

class _DemoPage extends State<DemoPage>{
  late DatabaseHandler handler;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final LastReading = TextEditingController();
  final PrevBill = TextEditingController();
  final kWH = TextEditingController();

  final columns = ['Date', 'Reading', 'kWH', 'Bill', 'Delete'];
  
  List<bill> bills = [];
  DateTime DateCreated = DateTime.now();


  @override
  void initState() {
     super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      bills = await this.handler.retrieveBill();
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
DataTableSource _data = MyData(bills, handler);
    return Column(
children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 70,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      DateCreated = newDateTime;
                    },
                    use24hFormat: false,
                    minuteInterval: 1,
                  ),
                ),
                TextFormField(
                  controller: LastReading,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      try {
                        final text = newValue.text;
                        if (text.isNotEmpty) double.parse(text);
                        return newValue;
                      } catch (e) {}
                      return oldValue;
                    })
                  ],
                  decoration: const InputDecoration(hintText: 'Last Reading'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input Last kWH reading';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: kWH,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      try {
                        final text = newValue.text;
                        if (text.isNotEmpty) double.parse(text);
                        return newValue;
                      } catch (e) {}
                      return oldValue;
                    })
                  ],
                  decoration: const InputDecoration(hintText: 'Amount per kWH'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input amount per kWH';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: PrevBill,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      try {
                        final text = newValue.text;
                        if (text.isNotEmpty) double.parse(text);
                        return newValue;
                      } catch (e) {}
                      return oldValue;
                    })
                  ],
                  decoration: const InputDecoration(hintText: 'Previous Bill'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input previous bill';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String response = '';
                        int res = await addBill(
                            DateCreated.toString(),
                            double.parse(LastReading.text),
                            double.parse(kWH.text),
                            double.parse(PrevBill.text));

                        bills = await this.handler.retrieveBill();
                       
                        setState(() {});
                        if (res > 0) {
                          response = "Succesfully Inserted!";
                        } else {
                          response =
                              "oooopps! Something went wrong! Response Code:" +
                                  res.toString();
                        }
                      }
                    },
                    child:const Text('Submit'),
                  ),
                ),
              ],
            )),
             Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: IconButton(icon: Icon(Icons.refresh),onPressed: () async{
                    bills = await this.handler.retrieveBill();
                        setState(() {});
                  },)
                ),
        Column(
          children: [
            SizedBox(
              height: 5,
              
            ),
            PaginatedDataTable(columns: getColumns(columns),
            source: _data,
            columnSpacing: 60,
            horizontalMargin: 5,
            rowsPerPage: 5,
            showCheckboxColumn: false,
            )
          ],
        ),
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

    Future<int> addBill(
    String dateTime, double lastreading, double kWH, double prevBill) async {
    bill _bill = bill(
        Date: dateTime,
        LastReading: lastreading,
        kWH: kWH,
        prevBill: prevBill,
        status: 'Active');
    this.handler.updateStatus();
    return await this.handler.insertBill(_bill);
  }
}