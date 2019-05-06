import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'firebase.dart';
import 'login_page.dart';
import 'package:flutter/services.dart';
import 'dart:math';

final budgetBoxHeight = 30.0;
final budgetBoxWidth = 400.0;
final numCount = 10;

TextEditingController amount = new TextEditingController();
TextEditingController category = new TextEditingController();

List<BudgetCategory> dataSample = [
  new BudgetCategory("Food", 500, 300, charts.MaterialPalette.green.shadeDefault),
  new BudgetCategory("Groceries", 500, 200, charts.MaterialPalette.blue.shadeDefault),
  new BudgetCategory("Potatoes", 600, 400, charts.MaterialPalette.pink.shadeDefault)
];

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: new Color(0xFF18D191),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBudgetPage()),
            );
          }
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 500,
            child: ListView(
              children: <Widget>[
                expensesListView(),
              ],
            ),
          )
        ],
      ),
    );
  }
  /*final noOfSelectedItems = 0;
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            body: _buildSuggestions(),
            floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: new Color(0xFF18D191),
              onPressed: () {
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
  */

}

List<BudgetCategory> sample() {

  List<BudgetCategory> sample = new List();

  budgetLimit2(userID).forEach((value)  {
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


    sample.add( BudgetCategory( value["budget category"],value["cost"], 50,
        charts.Color.fromHex( code: colorsForCharts[index]) ) );
  });

  print(budgetLimit2(userID));

  return sample;
}

class _expensesListViewState extends State<expensesListView>{
  //List<expensesListEntry> targetList = expensesListEntrySample;
  List<BudgetCategory> targetList = sample();

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: targetList.length,
      itemBuilder: (context,position){
        return Card(
          color: Colors.blue,
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
                              child:Text(targetList.elementAt(position).category, style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white)),
                            )
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              child: Text("5/6/2019", style: TextStyle(fontSize: 12.0, color: Colors.white))
                          ),
                        )
                      ]
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child:Container(
                          child:Text("\$"+targetList.elementAt(position).totalBudget.toString(),style: TextStyle(fontSize: 16.0,color:Colors.white))
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

/*class BudgetCategories extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}*/

class expensesListView extends StatefulWidget{
  @override
  State<expensesListView> createState(){
    return _expensesListViewState();
  }
}

class AddBudgetPage extends StatelessWidget {
  String newCategory = "";
  String newTotalBudget = "";
  String newBudgetSpent = "";

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
                        controller: category,
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
                        controller: amount,
                        keyboardType: TextInputType.number,
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
                          addBudget(userID, int.parse(amount.text), category.text);
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