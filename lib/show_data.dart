import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cap_6/moisutre_temp.dart';
import 'package:cap_6/co_temp.dart';
import 'package:cap_6/teble.dart';
import 'package:cap_6/methane_temp.dart';


class showReads extends StatefulWidget {
  const showReads({Key? key}) : super(key: key);
  @override
  State<showReads> createState() => _showReads();
}

class _showReads extends State<showReads> {
  final _database = FirebaseDatabase.instance.reference();
  dynamic temp = 0.00;
  dynamic moisture = 0.00;
  dynamic coConc = 0.00;
  dynamic methaneConc = 0.00;

  @override
  void initState() {
    _activateListners();
    super.initState();
  }

  void _activateListners() {
    _database.child('sensor/temp').onValue.listen((event) {
      final dynamic tempRead = event.snapshot.value as dynamic;
      setState(() {
        temp = tempRead;
      });
    });
    _database.child('sensor/moisture').onValue.listen((event) {
      final dynamic moistureRead = event.snapshot.value as dynamic;
      setState(() {
        if (moistureRead <= 0) {
          moisture = 0;
        } else if (moistureRead > 100){
          moisture = 100;
        }else {
          moisture=moistureRead ;
        }
      });
    });
    _database.child('sensor/co2Conc').onValue.listen((event) {
      final dynamic CoRead = event.snapshot.value as dynamic;
      setState(() {
        coConc = CoRead;
      });
    });
    _database.child('sensor/methaneConc').onValue.listen((event) {
      final dynamic methaneRead = event.snapshot.value as dynamic;
      setState(() {
        methaneConc = methaneRead;
      });
    });
  }

  MaterialColor T() {
    if (temp >= 30.00 && temp <= 70.00) {
      return Colors.orange;
    } else if (temp > 70.00) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  MaterialColor mo() {
    if (moisture >= 20 && moisture <= 50) {
      return Colors.green;
    } else if (moisture < 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  MaterialColor C() {
    if (coConc >= 1000 && coConc <= 2000) {
      return Colors.orange;
    } else if (coConc > 2000) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  MaterialColor M() {
    if (methaneConc >= 1000 && methaneConc <= 2000) {
      return Colors.orange;
    } else if (methaneConc > 2000) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sensors readings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    'Temberature',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 57,
                  ),
                  showData(temp, 'C', T(), 100)
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Moisture',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 91,
                  ),
                  showData(moisture, '%', mo(), 100)
                ],
              ),
              Row(
                children: [
                  const Text(
                    'CO2.Conc',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  showData(coConc, '\n ppm', C(), 100000)
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Methane.Conc',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  showData(methaneConc, '\n ppm', M(), 100000)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(children: [
                const Text(
                  'Normal readings',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                dataLabel(color: Colors.green)
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                const Text(
                  'Intrmediate Readings',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                dataLabel(color: Colors.orange)
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                const Text(
                  'Dangerous Readings',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                dataLabel(color: Colors.red)
              ]),
            ],
          ),
        ),
      )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.cyan,
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.water_drop,
                color: Colors.white,
              ),
              label: 'moisture - temperature',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          moistureTemp() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                      ),
                );
              }),
          SpeedDialChild(
              child: Icon(
                Icons.co2,
                color: Colors.white,
              ),
              label: 'Co2.Conc - temperature',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          coConcTemp() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                      ),
                );
              }),
          SpeedDialChild(
              child: Icon(
                Icons.air,
                color: Colors.white,
              ),
              label: 'Methane.Conc- temperature',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          methaneConcTemp() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                      ),
                );
              }),
          SpeedDialChild(
              child: Icon(
                Icons.table_chart,
                color: Colors.white,
              ),
              label: 'Table of data',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          dataTable() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                      ),
                );
              })
        ],
      ),
    );
  }

  Widget showData(dynamic value, String unit, Color Colr, dynamic scale) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 90,
              height: 90,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colr),
                  strokeWidth: 5,
                  value: value / scale,
                  backgroundColor: Colors.grey,
                ),
                Center(
                  child: Text(
                    '${value.toStringAsFixed(2).toString()} $unit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])),
        ],
      ),
    );
  }

  Container dataLabel({required Color color}) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color,
      ),
      alignment: Alignment.bottomLeft,
    );
  }
}
