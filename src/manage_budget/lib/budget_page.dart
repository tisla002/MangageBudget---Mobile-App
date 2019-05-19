import 'dart:ui';
import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'firebase.dart';
import 'login_page.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:manage_budget/data.dart';//FIXME Remove this?
import 'package:manage_budget/notifications.dart';
import 'package:manage_budget/creditsAndExpenses.dart';


final budgetBoxHeight = 30.0;
final budgetBoxWidth = 400.0;
final numCount = 10;
String _total_budget = "";
String _new_category = "";
String _color_selected = "";


TextEditingController amount = new TextEditingController();
TextEditingController category = new TextEditingController();
StreamSubscription _subscription;

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
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
//              height: 10000,
//              padding: const EdgeInsets.all(10.0),
//              color: Colors.green,
              child: expensesListView(),
            ),
          ],
      ),
    );
  }
}

List<BudgetCategory> sample() {

  List<BudgetCategory> sample = new List();

  budgetLimit2(returnUserID()).forEach((value)  {
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
    //print(value);
    //print(userID);
    var randStringIndexGen = new Random(1000);
    int index = randStringIndexGen.nextInt(11);


    sample.add( BudgetCategory( value["budget category"],value["cost"], totalBudgetExpense(value["budget category"]),
        colorPicker(value["color"]).dartColor/*charts.Color.fromHex( code: colorsForCharts[index])*/ ) );
  });
  
//print(budgetHistory2(userID, "Candy"));
  //print(budgetLimit2(userID));
  //FIXME Only putting here because I know this gets called somewhere
  initMaps();
  updateData();
  if(approachingLimit.isNotEmpty){
      approachingLimit.forEach((key, value){
        approachingLimitNotify(key, value);
      });
      approachingLimit.clear();
    }

  return sample;
}

class _expensesListViewState extends State<expensesListView>{
  List<BudgetCategory> targetList = sample();


  @override
  void initState(){
    FirebaseStream.getStream(returnUserID(),_update)
        .then((StreamSubscription s) => _subscription = s);
    super.initState();
  }

  _update(List<dynamic> value){
    setState(() {
      //this._budgetHistoryList = value;
      targetList = sample();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
        return ListView.builder(        //not scrolling, which is an issue
//          padding: const EdgeInsets.all(2.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: targetList.length,
        itemBuilder: (context,position) {
          return GestureDetector(
            onTap: ( ) {
              List<expensesListEntry> oof = expensesForBudgetsSample(targetList.elementAt(position).category);
              budgetBoxPressed(context, oof);
              oof.clear();
            },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget> [
                Card(
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.topRight,
                      child: Text("\$" + targetList.elementAt(position).budgetSpent.toString() + " of \$" + targetList.elementAt(position).totalBudget.toString(),style: TextStyle(fontSize: 16.0,color:Colors.green)), //color is added dynamically
                    )
                ),
                Card(
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(10.0),
                    child: Text(targetList.elementAt(position).category, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
                Card(
                  color: Colors.grey,
                  child: Container(
                    height: 48, //have to manually put in this value ._." (52, 65)
                    padding: const EdgeInsets.all(16.0),
                  )
                ),
                Card(
                color: targetList.elementAt(position).barColor,//Colors.green,  //this should be the color the user selected ie. targetList.elementAt(position).barColor
                child: FractionallySizedBox(
                  widthFactor: calcBudgetPercent(targetList.elementAt(position).totalBudget,
                             targetList.elementAt(position).budgetSpent),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 48,
//                    child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children:[
//                          Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children:[
//                                Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Container(
////                                    child:Text(targetList.elementAt(position).category, style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white)),
//                                    )
//                                ),
//                              ]
//                          ),
//                          Align(
//                              alignment: Alignment.centerRight,
//                              child:Container(
//                                height: 32,
////                                  child:Text("\$"+targetList.elementAt(position).budgetSpent.toString() + " of \$" +targetList.elementAt(position).totalBudget.toString(),style: TextStyle(fontSize: 16.0,color:Colors.white))
//                              )
//                          )
//                        ]
//                    ),
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
          backgroundColor: Colors.green,//new Color(0xFF18D191),
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
//                        onEditingComplete: (value) => _new_category = value,
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
                          
                          if (amount.text.isEmpty || category.text.isEmpty || _color_selected.isEmpty) {//|| _new_category.isEmpty) {
                            nothingEntered(context);
                          }
                          else {
                          addBudget(userID, int.parse(amount.text), category.text, _color_selected);
                            buttonPressed(context); //dummy onPressed does not look at the value
                            amount.clear();
                            category.clear();
                          }
                        },
                        child: Text('Enter'),
                      ),
                      new Container(
//                        height: 300,
                        child: BudgetColorChoices(),
                      )
                    ])
                ),
            ),
        );
  }
}

void nothingEntered(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Enter in your budget info fool, Look:\n category: " + category.text + ",\n budget: " + amount.text
      + ",\n color: " + _color_selected + ","),
    content: Text("I'm kidding don\'t hurt me pls", style: TextStyle(fontSize: 10.0),),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
  );
}

class BudgetColorChoices extends StatefulWidget {
  @override
  State<BudgetColorChoices> createState(){
    return _BudgetColorChoicesState();
  }
}

class _BudgetColorChoicesState extends State<BudgetColorChoices> {
  bool _tapInProgress = false; bool _tapInProgress2 = false;
  bool _tapInProgress3 = false; bool _tapInProgress4 = false;
  bool _tapInProgress5 = false; bool _tapInProgress6 = false;
  bool _tapInProgress7 = false; bool _tapInProgress8 = false;

  bool setAllFalse (bool _currentTap ) {
    bool temp = !_currentTap;
    _tapInProgress = false; _tapInProgress2 = false;
    _tapInProgress3 = false; _tapInProgress4 = false;
    _tapInProgress5 = false; _tapInProgress6 = false;
    _tapInProgress7 = false; _tapInProgress8 = false;

    if(temp == false) {
      _color_selected = "";
    }
    return temp;
  }



  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget> [
        new Row( children: <Widget> [Container (height: 10.0,)] ),
        new Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
              _color_selected = "blue";
              _tapInProgress = setAllFalse(_tapInProgress); });
            },
            /*onTapCancel: () {
              setState(() {
                _tapInProgress = false;});
              _color_selected = "";
            },*/
            child: Container(
            alignment: Alignment.centerRight,
                height: 50.0, width: 50.0,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: _tapInProgress? Colors.black:Colors.white,
                      width: 2.0,
                    )
                )
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _color_selected = "red";
                _tapInProgress2 = setAllFalse(_tapInProgress2); });
            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color: _tapInProgress2? Colors.black:Colors.white,
                  width: 2.0,
                )
              )
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _color_selected = "green";
                _tapInProgress3 = setAllFalse(_tapInProgress3); });

            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(
                  color: _tapInProgress3? Colors.black:Colors.white,
                  width: 2.0,
                )
              )
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _color_selected = "yellow";
                _tapInProgress4 = setAllFalse(_tapInProgress4); });

            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(
                  color: _tapInProgress4? Colors.black:Colors.white,
                  width: 2.0,
                )
              )
            ),
          ),

        ]
        ),
        new Row( children: <Widget> [Container (height: 10.0,)] ),
        new Row (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _color_selected = "pink";
                    _tapInProgress5 = setAllFalse(_tapInProgress5); });

                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        border: Border.all(
                          color: _tapInProgress5? Colors.black:Colors.white,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _color_selected = "lime";
                    _tapInProgress6 = setAllFalse(_tapInProgress6); });

                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.lime,
                        border: Border.all(
                          color: _tapInProgress6? Colors.black:Colors.white,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _color_selected = "teal";
                    _tapInProgress7 = setAllFalse(_tapInProgress7); });

                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        border: Border.all(
                          color: _tapInProgress7? Colors.black:Colors.white,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _color_selected = "indigo";
                    _tapInProgress8 = setAllFalse(_tapInProgress8); });
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        border: Border.all(
                          color: _tapInProgress8? Colors.black:Colors.white,
                          width: 2.0,
                        )
                    )
                ),
              ),

            ]
        ),
        new Row( children: <Widget> [Container (height: 10.0,)] ),
    ]
    );
  }

}


void buttonPressed(BuildContext context) {

//  Navigator.pop(context);
//  if(_new_category.isEmpty || _total_budget.isEmpty ) {
//    nothingEntered(context);
//  }
  var alertDialog = AlertDialog(
    title: Text("You have successfully entered in your budget"),
    content: Text("Thank you my dude"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    }
  );
}

void budgetBoxPressed(BuildContext context, List<expensesListEntry> targetList) {

  print(targetList);

  var alertDialog = AlertDialog(
    title: Text("OOF"),
    content: //Text("Hello?"),

    Container(
      width: double.maxFinite,
      height: 300.0,
      child: ListView(
        children:

        targetList.map((data)=> Text(data.item + " : \$" + data.amount.toString())).toList(),
      ),
    ),
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
  Color barColor;

  BudgetCategory(this.category, this.totalBudget, this.budgetSpent, this.barColor);
}

List<expensesListEntry> expensesForBudgetsSample(String category) {
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


  budgetHistory2(userID, category).forEach((val){
    index = randStringIndexGen.nextInt(11);
    if (val["budget category"] == category) {
      sample.add(expensesListEntry(val["expense description"],val["cost"],val["date"], charts.MaterialPalette.green.shadeDefault, Colors.green[600]));
    }

  });
  //print(budgetHistory(userID));
  print(sample[0]);

  return sample;
}


int totalBudgetExpense(String category) {
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

  int sampleTotal = 0;

  budgetHistory2(userID, category).forEach((val){
    print("category: " + category);
    print(val["expense description"]);
    index = randStringIndexGen.nextInt(11);
    if (val["budget category"] == category) {
      sampleTotal += val["cost"];
    }
  });

  return sampleTotal;
}





class _budgetExpensesListViewState extends State<budgetExpensesListView>{
  List<expensesListEntry> targetList = creditsAndExpensesSample();

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

class budgetExpensesListView extends StatefulWidget{
  @override
  State<budgetExpensesListView> createState(){
    return _budgetExpensesListViewState();
  }
}

