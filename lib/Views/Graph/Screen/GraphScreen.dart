import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  // Dummy data for the chart (replace with actual data from Google Earth Engine)
  final List<DataPoint> _chartData = [
    DataPoint(1, 30),
    DataPoint(2, 50),
    DataPoint(3, 20),
    DataPoint(4, 70),
    DataPoint(5, 40),
    DataPoint(6, 30),
    DataPoint(7, 50),
    DataPoint(8, 20),
    DataPoint(9, 70),
    DataPoint(10, 40),
    DataPoint(11, 40), // Use distinct x-values
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Graph Screen',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  LineSeries<DataPoint, int>(
                    dataSource: _chartData,
                    xValueMapper: (DataPoint data, _) => data.x,
                    yValueMapper: (DataPoint data, _) => data.y,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('X')),
                  DataColumn(label: Text('Y')),
                ],
                rows: _chartData.map(
                      (dataPoint) => DataRow(
                    cells: [
                      DataCell(Text(dataPoint.x.toString())),
                      DataCell(Text(dataPoint.y.toString())),
                    ],
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom data model for the chart
class DataPoint {
  final int x;
  final double y;

  DataPoint(this.x, this.y);
}
