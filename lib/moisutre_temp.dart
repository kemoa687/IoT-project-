import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class moistureTemp extends StatefulWidget {
  const moistureTemp({Key? key}) : super(key: key);
  @override
  State<moistureTemp> createState() => _moistureTemp();
}

class _moistureTemp extends State<moistureTemp> {
  final _database = FirebaseDatabase.instance.reference();
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  dynamic temp = 0;
  dynamic moisture = 0;
  dynamic lastTemp = 0;
  dynamic lastmoisture = 0;

  @override
  void initState() {
    intiateData();
    _activateListners();
    super.initState();
  }

  void _activateListners() {
    setState(() {
      _database.child('sensor/temp').onValue.listen((event) {
        temp = event.snapshot.value as dynamic;
        setState(() {
          chartData.add(LiveData(temp, moisture));
        });
      });
      _database.child('sensor/moisture').onValue.listen((event) {
        moisture = event.snapshot.value as dynamic;
        setState(() {
          chartData.add(LiveData(temp, moisture));
        });
      });
      chartData.add(LiveData(temp, moisture));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Graph of Temberature and Moisture',
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
                    yValueMapper: (LiveData sales, _) => sales.moisture,
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
                    title: AxisTitle(text: 'Moisture in %')))));
  }

  void intiateData() {
    chartData = [
      LiveData(0, 0),
      LiveData(temp, moisture)
    ];
  } // update the chart each second and remove the first point in each update to show only two points on the chart
}

class LiveData {
  LiveData(this.temp, this.moisture);

  final dynamic moisture;
  final dynamic temp;
} // get the data from the firebase and put it into a list of points
