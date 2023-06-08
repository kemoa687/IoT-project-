import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class methaneConcTemp extends StatefulWidget {
  const methaneConcTemp({Key? key}) : super(key: key);

  @override
  State<methaneConcTemp> createState() => _methaneConcTemp();
}

class _methaneConcTemp extends State<methaneConcTemp> {
  final _database = FirebaseDatabase.instance.reference();
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  dynamic temp = 0;
  dynamic methaneConc = 0;
  dynamic lastTemp = 0;
  dynamic lastmethaneConc = 0;

  @override
  void initState() {
    intiateData();
    _activateListners();
    //Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  void _activateListners() {
    setState(() {
      _database.child('sensor/temp').onValue.listen((event) {
        temp = event.snapshot.value as dynamic;
        setState(() {
          chartData.add(LiveData(temp, methaneConc));
        });
      });
      _database.child('sensor/methaneConc').onValue.listen((event) {
        methaneConc = event.snapshot.value as dynamic;
        setState(() {
          chartData.add(LiveData(temp, methaneConc));
        });
      });
      chartData.add(LiveData(temp, methaneConc));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Graph of Temberature and CO2.Conc',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: SfCartesianChart(
                series: <LineSeries<LiveData, dynamic>>[
                  LineSeries<LiveData, dynamic>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Colors.green,
                    xValueMapper: (LiveData sales, _) => sales.temp,
                    yValueMapper: (LiveData sales, _) => sales.methaneConc,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Temperature in C')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'CO2.Conc in ppm')))));
  }

  void intiateData() {
    chartData = [
      LiveData(0, 0),
      LiveData(temp, methaneConc)
    ];
  } // update the chart each second and remove the first point in each update to show only two points on the chart
}

class LiveData {
  LiveData(this.temp, this.methaneConc);

  final dynamic methaneConc;
  final dynamic temp;
} // get the data from the firebase and put it into a list of points
