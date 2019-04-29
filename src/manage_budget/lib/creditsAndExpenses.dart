import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'dart:math';

 List<charts.Series<GaugeSegment, String>> createData() {
  final data = [
  new GaugeSegment('Car', 5),
  ];

  return [
  new charts.Series<GaugeSegment, String>(
  id: 'Segments',
  domainFn: (GaugeSegment segment, _) => segment.segment,
  measureFn: (GaugeSegment segment, _) => segment.size,
  data: data,
  )
  ];
}

class creditsAndExpenses extends StatelessWidget {

 @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Credits And Expenses')),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //GaugeChart(createData()),
          Container(
            padding: EdgeInsets.only(left:5.0,top:10.0),
            child:
            ButtonTheme(
              minWidth: 400.0,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {},
                child: Text ("Add Credit",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),

        Container(
          padding: EdgeInsets.only(left:5.0,top:10.0),
          child:
            ButtonTheme(
              minWidth: 400.0,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {},
                child: Text("Add Expenses",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
        ),
        Container(
          padding: EdgeInsets.only(left:5.0,top:10.0),
          child:
          ButtonTheme(
            minWidth: 400.0,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {},
              child: Text("Expense Report",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ),

        ],
      ),

    );
 }

}

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory GaugeChart.withSampleData() {
    return new GaugeChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Car', 75),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: new creditsAndExpenses(),
    ));
  });
}