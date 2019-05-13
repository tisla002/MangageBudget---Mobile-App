import 'dart:ui';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'firebase.dart';
import 'login_page.dart';
import 'package:flutter/services.dart';
import 'dart:math';

final budgetBoxHeight = 30.0;
final budgetBoxWidth = 400.0;
final numCount = 10;
String _total_budget = "";
String _new_category = "";

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
          backgroundColor: Colors.green, //new Color(0xFF18D191),
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
            height: 700,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                /*Row(
                  children: <Widget> [
                    Expanded(
                      child: Text('spacing'),
                    )
                  ]
                ),*/
                expensesListView(),
              ],
            ),
          )
        ],
      ),
    );
  }
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


    sample.add( BudgetCategory( value["budget category"],value["cost"], 200,
        charts.Color.fromHex( code: colorsForCharts[index]) ) );
  });

  print(budgetLimit2(userID));

  return sample;
}

class _expensesListViewState extends State<expensesListView>{
  List<BudgetCategory> targetList = sample();

  @override
  Widget build(BuildContext context){
    /*return GestureDetector(
      onTap: ( ) {
         //Todo on tap gesture
      },
      child:*/ return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: targetList.length,
        itemBuilder: (context,position) {
          return GestureDetector(
            onTap: ( ) {
              budgetBoxPressed(context);
            },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget> [
                Card(
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(10.0),
                    child: Text(targetList.elementAt(position).category, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
                Card(
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.topRight,
                    child: Text("yoooo" ),
                  )
                ),
                Card(
                  color: Colors.grey,
                  child: Container(
                    height: 52, //have to manually put in this value ._." (52, 65)
                    padding: const EdgeInsets.all(16.0),
                  )
                ),
                Card(
                color: Colors.green,
                child: FractionallySizedBox(
                  widthFactor: calcBudgetPercent(targetList.elementAt(position).totalBudget,
                             targetList.elementAt(position).budgetSpent),
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
//                                    child:Text(targetList.elementAt(position).category, style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white)),
                                    )
                                ),
                              ]
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:Container(
                                  child:Text("\$"+targetList.elementAt(position).budgetSpent.toString() + " of \$" +targetList.elementAt(position).totalBudget.toString(),style: TextStyle(fontSize: 16.0,color:Colors.white))
                              )
                          )
                        ]
                    ),
                  ),
                ),
              ),
             ]
            ),
          );
        },
//      ),
    );
  }
}

class expensesListView extends StatefulWidget{
  @override
  State<expensesListView> createState(){
    return _expensesListViewState();
  }
}

class AddBudgetPage extends StatelessWidget {

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
                      new TextFormField(
                        controller: category,
                        decoration: new InputDecoration(
                          hintText: "Add your category",
                        ),
                        maxLines: 1,
                        maxLength: 40,  //variable length
                        maxLengthEnforced: true,
                        validator: (value) => value.isEmpty ? "Category cannot be empty you noob" : null,
                        onSaved: (value) => _new_category = value,
                        onFieldSubmitted: (String str) {
                          //setState(() {
                          _new_category = str;
//                            buttonPressed(context);
                          //});
                        },

                      ),
                      new TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          hintText: "Add your total budget",
                        ),
                        maxLines: 1,
                        maxLength: 20,
                        maxLengthEnforced: true,
                        validator: (value) => value.isEmpty ? "Budget cannot be empty you dingdong" : null,
                        onSaved: (value) => _total_budget = value,  //value is not being saved
                        onFieldSubmitted: (String str1) {
                          _total_budget = str1;
//                          buttonPressed(context);
                        },
                      ),
                      new RaisedButton(
                        onPressed: () {
                          if (_total_budget.isEmpty || _new_category.isEmpty) {//|| _new_category.isEmpty) {
                            nothingEntered(context);
                          }
                          else {
                          addBudget(userID, int.parse(amount.text), category.text);
                            buttonPressed(context); //dummy onPressed does not look at the value
                          }
                        },
                        child: Text('Enter'),
                      ),
                    ])
                ),
            ),
        );
  }
}

void nothingEntered(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Enter in your budget info fool, Look: " + _total_budget + " , " + _new_category),
    content: Text("I'm kidding don\'t hurt me pls", style: TextStyle(fontSize: 10.0),),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    }
  );
}

void buttonPressed(BuildContext context) {

//  Navigator.pop(context);
//  if(_new_category.isEmpty || _total_budget.isEmpty ) {
//    nothingEntered(context);
//  }
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

void budgetBoxPressed(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("This function does not work"),
    content: Text("We're working on it :("),
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
  );

}

double calcBudgetPercent(int total, int spent) {
  double percent;

//  percent = spent.toDouble() - total.toDouble();

  percent = spent.toDouble() / total.toDouble();

  if(percent > 1.000) {
    percent = 1.000;
  }

  return percent;
}

class BudgetCategory {
  final String category;
  final int totalBudget;
  final int budgetSpent;
  charts.Color barColor;

  BudgetCategory(this.category, this.totalBudget, this.budgetSpent, this.barColor);
}

//comment im here