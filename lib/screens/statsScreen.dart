import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/data/dbManager.dart';

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
          Expanded(
            // height: 250,
            child: Content(),
          ),

          Container(
            padding: EdgeInsets.only(top: 30, bottom: 15),
            child: Column(
              children: <Widget>[
                Text('Completed: 29 task', style: mainTheme.textTheme.body1,),
                
                Padding(padding: EdgeInsets.only(top: 15),),

                Text('Percentage: 10%', style: mainTheme.textTheme.body1,),
              ],
            ),
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

class Data {
  final DateTime date;
  final double time;

  Data(this.date, this.time);
}

List<charts.Series<Data, DateTime>> _createRandomData() {
  final DbManager dbManager = DbManager.instance;

  // TODO: take data from dbManager and remove hardcoded values
  final List<Data> data = [
    new Data(new DateTime(2017, 9, 15), 2),
    new Data(new DateTime(2017, 9, 31), 12),
    new Data(new DateTime(2017, 10, 2), 11),
    new Data(new DateTime(2017, 10, 25), 15),
  ];

  return [
    new charts.Series<Data, DateTime>(
      id: 'Time',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Data time, _) => time.date,
      measureFn: (Data time, _) => time.time,
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
      animate: true,
      defaultRenderer: new charts.LineRendererConfig(
        radiusPx: 2,
        strokeWidthPx: 1,
        includePoints: true
      ),
      behaviors: [
        new charts.LinePointHighlighter(
          showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
        ),
      ],

      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredMaxTickCount: 3,
        ),

        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
          ),

          labelOffsetFromAxisPx: 15,

          lineStyle: new charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),

      domainAxis: new charts.DateTimeAxisSpec(
        tickProviderSpec: new charts.DayTickProviderSpec(
          increments: [10],
        ),

        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MMM dd')),
                  
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
          ),

          labelOffsetFromAxisPx: 15,

          lineStyle: new charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        )
      ),
    );
  }
}