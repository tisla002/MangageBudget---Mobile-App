import 'dart:core';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'dart:math';

final budgetBoxHeight = 30.0;
final budgetBoxWidth = 400.0;
final numCount = 10;


List<BudgetCategory> dataSample = [
  new BudgetCategory("Food", 500, 300, charts.MaterialPalette.green.shadeDefault),
  new BudgetCategory("Groceries", 500, 200, charts.MaterialPalette.blue.shadeDefault),
  new BudgetCategory("Potatoes", 600, 400, charts.MaterialPalette.pink.shadeDefault),
//  new BudgetCategory("Food", 500, charts.MaterialPalette.green.shadeDefault),
//  new BudgetCategory("Food", 500, charts.MaterialPalette.green.shadeDefault),
//  new BudgetCategory("Food", 500, charts.MaterialPalette.green.shadeDefault),
//  new BudgetCategory("Food", 500, charts.MaterialPalette.green.shadeDefault),

];


//don't think I need this
//for (int i = 0; i < targetList.length;i++) {
//  dataSample.add(BudgetCategory(targetList.elementAt(i).category, targetList.elementAt(i).totalBudget,
//    targetList.elementAt(i).color))
//}

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BudgetPageState();//_BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final noOfSelectedItems = 0;
  final _medFont = const TextStyle(fontSize: 20.0);
//  List<charts.Series<BudgetCategory, String>> _seriesData;
//  final _biggerFont = const TextStyle(fontSize: 18.0);

//  _generateData() {
//    var data1 = [
//      new BudgetCategory('food', 100, charts.MaterialPalette.green.shadeDefault),
////      new BudgetCategory('gas', 500, charts.MaterialPalette.pink.shadeDefault),
////      new BudgetCategory('bills', 100, charts.MaterialPalette.red.shadeDefault),
////      new BudgetCategory('groceries', 300, charts.MaterialPalette.blue.shadeDefault),
//    ];
//
//    _seriesData.add(
//        charts.Series(
//          data: data1,
//          domainFn: (BudgetCategory budget, _) => budget.category,
//          measureFn: (BudgetCategory budget, _) => budget.totalBudget,
//          colorFn: (BudgetCategory budget, _) => budget.color,
//          id: 'Total',
//        )
//    );
//  }

//  @override
//  void initState() {
//    super.initState();
//    _seriesData = List<charts.Series<BudgetCategory, String>>();
//    _generateData();
//
//  }
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            /*appBar: AppBar(
              backgroundColor: new Color(0xFF18D191),
              title: Text('BudgetPage', style: _medFont)
            ),*/
            body: _buildSuggestions(),
            floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: new Color(0xFF18D191), //color....
              onPressed: () {
                //Navigator.of(context).pushNamed("/AddBudgetPage");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBudgetPage()),
                );
              }
            )
          );
        }
        Widget _buildSuggestions() {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
                itemCount: dataSample.length, //dummy value
                itemBuilder: (context, i) {
//                  if (i.isOdd) return Divider();

                  return _buildRow(dataSample, i);
                }
          );
        }

        Widget _buildRow(dataSample, i) {

          return new GestureDetector(
            onTap: () {  },
            child: Stack(

            alignment: Alignment.centerLeft,

            children: <Widget>[
              SizedBox(

                width: budgetBoxWidth,
                height: budgetBoxHeight,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,

                ),
              ),
              SizedBox(

                width: (dataSample.elementAt(i).budgetSpent / dataSample.elementAt(i).totalBudget) * budgetBoxWidth,
                height: budgetBoxHeight,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  color: Colors.green, //dataSample.elementAt(i).barColor,
                  child: Text(dataSample.elementAt(i).category, style: TextStyle(color: Colors.white)),

                ),
              ),
            ],
            )
          );
        }

//        Widget _buildBasicRow() {
//           return Stack(
//
//             alignment: Alignment.centerLeft,
//             children: <Widget> [
//               SizedBox(
//                 width: budgetBoxWidth, //dummy value
//                 height: budgetBoxHeight,
//                 child: Container(
//                   alignment: Alignment.center,
//                   color: Colors.grey,
//                   child:Text('Total'),
//                 ),
//               ),
//               SizedBox(
//                 width: 75, //dummy value
//                 height: budgetBoxHeight,
//                 child: Container(
//                   alignment: Alignment.center,
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           );
//        }
}

class BudgetCategories extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}


class AddBudgetPage extends StatelessWidget {
  String newCategory = "";
  String newTotalBudget = "";
  String newBudgetSpent = "";

//  void onPressed() {
//    setState(() {
//      new Text(newCategory);
//    });
//  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: new Color(0xFF18D191),
          title: new Text('Input Budget'),
        ),
        body: new Container(
            padding: new EdgeInsets.all(32.0),
            child: new Center(
                child: new Column(
                    children: <Widget>[
                      new TextField(
                        decoration: new InputDecoration(
                          hintText: "Add your category",
                        ),
                        onSubmitted: (String str) {
                          //setState(() {
                            newCategory = str;
                            buttonPressed(context);
                          //});
                        },
                      ),
                      new TextField(
                        decoration: new InputDecoration(
                          hintText: "Add your total budget",
                        ),
                        onSubmitted: (String str1) {
                          newTotalBudget = str1;
                          buttonPressed(context);
                        }
                      ),
                      new RaisedButton(
                        onPressed: () {
                          buttonPressed(context); //dummy onPressed does not look at the value

                        },
                        child: Text('Enter'),
                      ),
//
                    ])
                ),
            ),
        );
  }
}

void buttonPressed(BuildContext context) {

  Navigator.pop(context);

  var alertDialog = AlertDialog(
    title: Text("You have pressed a button successfully"),
    content: Text("Thank you, your data is stored"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    }
  );
}

class BudgetCategory {
  final String category;
  final int totalBudget;
  final int budgetSpent;
  charts.Color barColor;

  BudgetCategory(this.category, this.totalBudget, this.budgetSpent, this.barColor);
}