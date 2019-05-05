import 'dart:core';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manage_budget/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'dart:math';
import 'login_page.dart';

 TextEditingController addcreditscontroller = new TextEditingController();


 List<charts.Series<GaugeSegment, String>> createData(List<expensesListEntry> targetList) {
   List<GaugeSegment> data = [];

   for (int i=0;i < targetList.length;i++){
     data.add(GaugeSegment(targetList.elementAt(i).item, targetList.elementAt(i).amount,targetList.elementAt(i).color));
   }


  return [
  new charts.Series<GaugeSegment, String>(
  id: 'Segments',
  domainFn: (GaugeSegment segment, _) => segment.segment,
  measureFn: (GaugeSegment segment, _) => segment.size,
  colorFn: (GaugeSegment segment, _) => segment.color,
  data: data,
  )
  ];
}

class creditsAndExpensesPage extends StatelessWidget {

 @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomPadding: false,
     /* appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed:() {Navigator.pop(context);} ),
          title: Text('Credits And Expenses'),
          actions: <Widget>[
            IconButton(icon:Icon(Icons.settings),onPressed: null)
          ],
      ),*/


      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            //child: GaugeChart(createData(expensesListEntrySample)),
            child: GaugeChart(createData(sample())),
          ),

          Container(
            padding: EdgeInsets.only(left:5.0,top:10.0),
            child:
            ButtonTheme(
              minWidth: 400.0,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  showDialog(context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: new Text("Add Credits: "),
                      content: new TextField(
                        decoration: new InputDecoration(labelText: "Enter your number"),
                        controller: addcreditscontroller,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                      ),
                      actions: <Widget>[
                        ButtonTheme(
                        minWidth:150,
                        child:
                          new RaisedButton.icon(
                              icon: new Icon(Icons.check,color: Colors.white),
                              disabledColor: Colors.grey,
                              color: Colors.green,
                              onPressed: () {
                                addCredit(userID, int.parse(addcreditscontroller.text), "5/4/2019", "test");
                                //sample();
                              },
                              label: Text("")
                          ),
                        ),

                        ButtonTheme(
                        minWidth:150,
                        child:
                          new RaisedButton.icon(
                            icon: new Icon(Icons.close,color: Colors.white),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: Text(""),
                          ),
                        )
                      ],
                    );
                  });
                },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detailedReportPage()),
                );
              },
              child: Text("View Detailed Report",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top:10),
          child: SizedBox(

          ),
          /*
            AppBar(
              title: Text("Expenses",
                style: TextStyle(
                  color: Colors.white,
                )
              ),
            )*/
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

List<expensesListEntry> sample() {
  //new expensesListEntry("Winson", 50, "4/1/2019", charts.MaterialPalette.purple.shadeDefault);
  List<expensesListEntry> sample = new List();
  grabHistory(userID).forEach((value){
    //TODO: fix charts.Color.fromHex()
    sample.add(expensesListEntry(value["description"],value["amount"],value["date"], charts.Color.fromHex()));
  });
  //print(grabHistory(userID));
  //print(sample);

  return sample;
}


class _expensesListViewState extends State<expensesListView>{
   //List<expensesListEntry> targetList = expensesListEntrySample;
    List<expensesListEntry> targetList = sample();

   @override
    Widget build(BuildContext context){
     return ListView.builder(
       itemCount: targetList.length,
       itemBuilder: (context,position){
         return Card(
           color: Colors.green,
           child: Container(
             padding: const EdgeInsets.all(16.0),
             child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children:[
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:[
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Container(
                         child:Text(targetList.elementAt(position).item, style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white)),
                       )
                     ),
                     Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(targetList.elementAt(position).date, style: TextStyle(fontSize: 12.0, color: Colors.white))
                        ),
                     )
                    ]
                 ),
                 Align(
                   alignment: Alignment.centerRight,
                   child:Container(
                     child:Text("\$"+targetList.elementAt(position).amount.toString(),style: TextStyle(fontSize: 16.0,color:Colors.white))
                   )
                 )
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
   charts.Color color;

   expensesListEntry(this.item,this.amount,this.date,this.color);
}

List<expensesListEntry> expensesListEntrySample = [
  new expensesListEntry("Winson", 50, "4/1/2019", charts.MaterialPalette.purple.shadeDefault),
  new expensesListEntry("Staters's Bros", 150, "4/2/2019", charts.MaterialPalette.deepOrange.shadeDefault),
  new expensesListEntry("AT&T",49, "4/2/2019", charts.MaterialPalette.red.shadeDefault),
  new expensesListEntry("Edison",39,"4/10/2019", charts.MaterialPalette.blue.shadeDefault),
  new expensesListEntry("Poo", 100, "4/1/2019", charts.MaterialPalette.green.shadeDefault),
  new expensesListEntry("Walmart", 150, "4/2/2019", charts.MaterialPalette.deepOrange.shadeDefault),
  new expensesListEntry("Verizon",49, "4/2/2019", charts.MaterialPalette.red.shadeDefault),
  new expensesListEntry("Apple",39,"4/10/2019", charts.MaterialPalette.blue.shadeDefault),
  new expensesListEntry("Lincoln", 100, "4/1/2019", charts.MaterialPalette.green.shadeDefault),
  new expensesListEntry("McDonalds", 100, "4/1/2019", charts.MaterialPalette.purple.shadeDefault),
  new expensesListEntry("Vons", 150, "4/2/2019", charts.MaterialPalette.deepOrange.shadeDefault),
  new expensesListEntry("Jack in the Box",49, "4/2/2019", charts.MaterialPalette.red.shadeDefault),
  new expensesListEntry("Wendy's",39,"4/10/2019", charts.MaterialPalette.blue.shadeDefault),
  new expensesListEntry("Burger King", 100, "4/1/2019", charts.MaterialPalette.green.shadeDefault),
];



class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 0,
      child:
      charts.PieChart(seriesList,
          animate: animate,
          // Configure the width of the pie slices to 30px. The remaining space in
          // the chart will be left as a hole in the center. Adjust the start
          // angle and the arc length of the pie so it resembles a gauge.
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 30, startAngle: -7/6 *pi, arcLength: 6.7 / 5 * pi))
    );
  }
}

class GaugeSegment {
  final String segment;
  final int size;
  charts.Color color;

  GaugeSegment(this.segment, this.size,this.color);
}

class detailedReportPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed:() {Navigator.pop(context);} ),
        title: Text('Detailed Report'),
        actions: <Widget>[
          IconButton(icon:Icon(Icons.settings),onPressed: null)
        ],
      ),

    );
  }
}

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: new creditsAndExpensesPage(),
    ));
  });
}