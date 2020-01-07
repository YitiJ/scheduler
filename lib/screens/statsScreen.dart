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
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      child: Column(
        children: <Widget> [
          Text(
            'Statistics',
            style: mainTheme.textTheme.subtitle,
          ),
          SizedBox(
            height: 250,
            child: Content(),
          ),
        ],
      ),
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

List<charts.Series<LinearStat, DateTime>> _createRandomData() {
  final data = [
    new LinearStat(new DateTime(2017, 9, 25), 2),
    new LinearStat(new DateTime(2017, 9, 31), 12),
    new LinearStat(new DateTime(2017, 10, 2), 11),
    new LinearStat(new DateTime(2017, 10, 15), 15),
  ];

  return [
    new charts.Series<LinearStat, DateTime>(
      id: 'Time',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearStat time, _) => time.date,
      measureFn: (LinearStat time, _) => time.time,
      data: data,
    )
  ];
}

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  SimpleLineChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: false,

      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
          ),

          labelOffsetFromAxisPx: 15,
        ),
      ),

      domainAxis: new charts.DateTimeAxisSpec(
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MM/dd/yyyy')),
        showAxisLine: true,
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
            lineHeight: 3,
          ),
        )
      ),
    );
  }
}

/// Sample linear data type.
class LinearStat {
  final DateTime date;
  final double time;

  LinearStat(this.date, this.time);
}