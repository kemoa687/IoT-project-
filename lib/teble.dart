import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class dataTable extends StatefulWidget {
  const dataTable({Key? key}) : super(key: key);

  @override
  State<dataTable> createState() => _dataTableState();
}

class _dataTableState extends State<dataTable> {
  final _database = FirebaseDatabase.instance.reference();
  dynamic temp = 0;
  dynamic moisture = 0;
  dynamic coConc = 0.00;
  dynamic methaneConc = 0.00;
  late MyData _data;
  final numberOfRows = 10;
  dynamic time = 0;

  @override
  void initState() {
    _data = MyData.dynamiciation(numberOfRows: numberOfRows);
    _activateListners();
    super.initState();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
  }

  void _activateListners() {
    _database.child('sensor/temp').onValue.listen((event) {
      temp = event.snapshot.value as dynamic;
    });
    _database.child('sensor/moisture').onValue.listen((event) {
      moisture = event.snapshot.value as dynamic;
      if (moisture <= 0) {
        moisture = 0;
      } else if (moisture > 100) {
        moisture = 100;
      } else {
        moisture;
      }
    });
    _database.child('sensor/co2Conc').onValue.listen((event) {
      coConc = event.snapshot.value as dynamic;
    });
    _database.child('sensor/methaneConc').onValue.listen((event) {
      methaneConc = event.snapshot.value as dynamic;
    });
  }

  void updateDataSource(Timer timer) {
    _activateListners();
    setState(() {
      _data.updateData(
          temp: temp,
          moisture: moisture,
          time: time,
          coConc: coConc,
          methaneConc: methaneConc);
      _data = MyData(numberOfRows: numberOfRows);
    });
    time++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Table of data'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.white,
                  // dividerColor: Colors.white,
                ),
                child: PaginatedDataTable(
                  source: _data,
                  columns: const [
                    DataColumn(
                        label: Text("Time",
                            style: TextStyle(color: Colors.green))),
                    DataColumn(
                        label: Text('Tempreture',
                            style: TextStyle(color: Colors.green))),
                    DataColumn(
                        label: Text('Moisture',
                            style: TextStyle(color: Colors.green))),
                    DataColumn(
                        label: Text('CO2.Conc',
                            style: TextStyle(color: Colors.green))),
                    DataColumn(
                        label: Text('Methane.Conc',
                            style: TextStyle(color: Colors.green)))
                  ],
                  header: const Center(
                      child: Text(
                    'Sensor Readings',
                    style: TextStyle(color: Colors.green),
                  )),
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  rowsPerPage: numberOfRows,
                ),
              )
            ],
          ),
        ));
  }
}

class MyData extends DataTableSource {
  late dynamic tempRead, moistureRead, coRead, methaneRead;

  static List<Map<String, dynamic>> _data = [];
  static dynamic counter = 0;
  late dynamic numberOfRows;

  MyData(
      {this.tempRead = 0,
      this.moistureRead = 0,
      required this.numberOfRows,
      this.coRead,
      this.methaneRead});

  MyData.dynamiciation(
      {this.tempRead = 0,
      this.moistureRead = 0,
      required this.numberOfRows,
      this.coRead,
      this.methaneRead}) {
    _data = List.generate(numberOfRows, (index) {
      return {
        "Time,": "__",
        "Tempreture": "__",
        "moisture": "__",
        'CO2.Conc': '__',
        'Methane.Conc': '__',
      };
    });
  }

  updateData({temp, moisture, time, coConc, methaneConc}) {
    _data.removeAt(_data.length - 1);
    _data.insert(0, {
      "Time": time,
      "Tempreture": temp,
      "moisture": moisture,
      'CO2.Conc': coConc,
      'Methane.Conc': methaneConc
    });
  }

  @override
  DataRow? getRow(dynamic index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['Time'].toString(),
          style: TextStyle(color: Colors.green))),
      DataCell(Text(_data[index]['Tempreture'].toString(),
          style: TextStyle(color: Colors.green))),
      DataCell(Text(_data[index]["moisture"].toString(),
          style: TextStyle(color: Colors.green))),
      DataCell(Text(_data[index]["CO2.Conc"].toString(),
          style: TextStyle(color: Colors.green))),
      DataCell(Text(_data[index]["Methane.Conc"].toString(),
          style: TextStyle(color: Colors.green))),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
