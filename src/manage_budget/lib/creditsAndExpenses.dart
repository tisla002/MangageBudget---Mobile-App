import 'dart:core';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'dart:math';

 List<charts.Series<GaugeSegment, String>> createData(List<expensesListEntry> targetList) {
   List<GaugeSegment> data = [];

   for (int i=0;i < targetList.length;i++){
     data.add(GaugeSegment(targetList.elementAt(i).item, targetList.elementAt(i).amount));
   }


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
          Container(
            height: 200,
            child: GaugeChart(createData(expensesListEntrySample)),
          ),
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
              child: Text("View Detailed Report",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top:10),
          child:
            AppBar(title: Text("Expenses",style: TextStyle(
              color: Colors.white,
            )),)
        ),
        Container(
          height:306,
          child:
            expensesListView(),
        ),

        ],
      ),

    );
 }

}

class expensesListView extends StatefulWidget{
  @override
  State<expensesListView> createState(){
    return _expensesListViewState();
  }
}

class _expensesListViewState extends State<expensesListView>{
   List<expensesListEntry> targetList = expensesListEntrySample;

   @override
    Widget build(BuildContext context){
     return ListView.builder(
       itemCount: targetList.length,
       itemBuilder: (context,position){
         return Card(
           child: Container(
             padding: const EdgeInsets.all(16.0),
             child: Row(
               children:[
                 Text( targetList.elementAt(position).item, style: TextStyle(fontSize: 14.0),
                 ),
               ]
             ),
           ),
         );
        },
     );
   }
}


class expensesListEntry{
   final String item;
   final int amount;
   final String date;

   expensesListEntry(this.item,this.amount,this.date);
}

List<expensesListEntry> expensesListEntrySample = [
  new expensesListEntry("Car", 100, "4/1/2019"),
  new expensesListEntry("Staters's Bros", 150, "4/2/2019"),
  new expensesListEntry("AT&T",49, "4/2/2019"),
  new expensesListEntry("Edison",39,"4/10/2019"),
  new expensesListEntry("Car", 100, "4/1/2019"),
  new expensesListEntry("Staters's Bros", 150, "4/2/2019"),
  new expensesListEntry("AT&T",49, "4/2/2019"),
  new expensesListEntry("Edison",39,"4/10/2019"),
  new expensesListEntry("Car", 150, "4/1/2019"),
  new expensesListEntry("Staters's Bros", 150, "4/2/2019"),
  new expensesListEntry("AT&T",49, "4/2/2019"),
  new expensesListEntry("Edison",39,"4/10/2019"),
];

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate});

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
      new GaugeSegment('Car', 50),
      new GaugeSegment('Phone', 20)
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