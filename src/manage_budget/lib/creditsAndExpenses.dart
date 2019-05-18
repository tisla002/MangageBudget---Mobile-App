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
StreamSubscription _subscriptionHistoryStream;
List<dynamic> _budgetHistoryList2;


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
                                addCredit(userID, int.parse(addcreditscontroller.text), "5/4/2019", "Credit");
                                Navigator.of(context).pop();
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
          height:500,
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

List<expensesListEntry> creditsAndExpensesSample() {
  //new expensesListEntry("Winson", 50, "4/1/2019", charts.MaterialPalette.purple.shadeDefault);
  List<String> colorsForCharts= new List(12);
  colorsForCharts[0] = "FFFF5722";
  colorsForCharts[1] = "FF00C853";
  colorsForCharts[2] = "FF004D40";
  colorsForCharts[3] = "FFFFEB3B";
  colorsForCharts[4] = "FFCDDC39";
  colorsForCharts[5] = "FFB2FF59";
  colorsForCharts[6] = "FF009688";
  colorsForCharts[7] = "FF00BCD4";
  colorsForCharts[8] = "FF2196F3";
  colorsForCharts[9] = "FF3f51B5";
  colorsForCharts[10] = "FF9C27B0";
  colorsForCharts[11] = "FF607D8B";

  var randStringIndexGen = new Random(1000);
  int index = randStringIndexGen.nextInt(11);

  List<expensesListEntry> sample = new List();

  //budgetHistoryList = budgetHistory(userID);


  budgetHistory(userID).forEach((value){
    index = randStringIndexGen.nextInt(11);
    sample.add(expensesListEntry(value["expense description"],value["cost"],value["date"], charts.Color.fromHex(code: colorsForCharts[index]), Colors.red[600]));
  });

  grabHistory(userID).forEach((val){
    index = randStringIndexGen.nextInt(11);
    sample.add(expensesListEntry(val["description"],val["amount"],val["date"], charts.MaterialPalette.green.shadeDefault, Colors.green[600]));
  });

  //print(budgetHistory(userID));
  //print(grabHistory(userID));
  //print(sample);

  return sample;
}

class _expensesListViewState extends State<expensesListView>{
   //List<expensesListEntry> targetList = expensesListEntrySample;

    List<dynamic> _budgetHistoryList;
    List<expensesListEntry> targetList = creditsAndExpensesSample();

    @override
    void initState(){
      FirebaseStream.getStream(userID,_update)
          .then((StreamSubscription s) => _subscriptionHistoryStream = s);
      super.initState();

    }

    _update(List<dynamic> value){
      setState(() {
        //this._budgetHistoryList = value;
        targetList = creditsAndExpensesSample();
      });
      print(value);
    }

    @override
    void dispose() {
      _subscriptionHistoryStream.cancel();
      super.dispose();
    }

   @override
    Widget build(BuildContext context){
     return ListView.builder(
       itemCount: targetList.length,
       itemBuilder: (context,position){
         return Card(
           color: targetList.elementAt(position).boxColor,
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
   Color boxColor;

   expensesListEntry(this.item,this.amount,this.date,this.color, this.boxColor);
}

List<expensesListEntry> expensesListEntryPull(){

}

/*List<expensesListEntry> expensesListEntrySample = [
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
];*/
class colorPickerEntry{
  final Color dartColor;
  final charts.Color chartColor;

  colorPickerEntry(this.dartColor,this.chartColor);
}
List<colorPickerEntry> colorPickerList = [
  new colorPickerEntry(Colors.blue,charts.MaterialPalette.blue.shadeDefault),
  new colorPickerEntry(Colors.red,charts.MaterialPalette.red.shadeDefault),
  new colorPickerEntry(Colors.green,charts.MaterialPalette.green.shadeDefault),
  new colorPickerEntry(Colors.yellow,charts.MaterialPalette.yellow.shadeDefault),
  new colorPickerEntry(Colors.pink,charts.MaterialPalette.pink.shadeDefault),
  new colorPickerEntry(Colors.lime, charts.MaterialPalette.lime.shadeDefault),
  new colorPickerEntry(Colors.teal,charts.MaterialPalette.teal.shadeDefault),
  new colorPickerEntry(Colors.indigo, charts.MaterialPalette.indigo.shadeDefault)
];
colorPickerEntry colorPicker(String targetString){
  if (targetString == "blue") {return colorPickerList.elementAt(0);}
  if (targetString == "red") {return colorPickerList.elementAt(1);}
  if (targetString == "green") {return colorPickerList.elementAt(2);}
  if (targetString == "yellow") {return colorPickerList.elementAt(3);}
  if (targetString == "pink") {return colorPickerList.elementAt(4);}
  if (targetString == "lime") {return colorPickerList.elementAt(5);}
  if (targetString == "teal") {return colorPickerList.elementAt(6);}
  if (targetString == "indigo") {return colorPickerList.elementAt(7);}

}
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
              arcWidth: 50, startAngle: -7/6 *pi, arcLength: 6.7 / 5 * pi))
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
