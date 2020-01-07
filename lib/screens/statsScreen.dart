import 'package:flutter/material.dart';
import 'dart:math';

import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/data/dbManager.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class StatsScreen extends StatelessWidget {
  StatsScreen({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Content(),
    );
  }
}

class Content extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: SimpleLineChart(_createRandomData()),
    );
  }
}

List<charts.Series<LinearSales, num>> _createRandomData() {
  final random = new Random();

  final data = [
    new LinearSales(0, random.nextInt(100)),
    new LinearSales(1, random.nextInt(100)),
    new LinearSales(2, random.nextInt(100)),
    new LinearSales(3, random.nextInt(100)),
  ];

  return [
    new charts.Series<LinearSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
    )
  ];
}

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  SimpleLineChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: false,

      // primaryMeasureAxis: new charts.NumericAxisSpec(
      //   showAxisLine: true,
      //   renderSpec: new charts.NoneRenderSpec(),
      // ),

      // domainAxis: new charts.NumericAxisSpec(
      //   showAxisLine: true,
      //   renderSpec: new charts.NoneRenderSpec(),
      // ),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}