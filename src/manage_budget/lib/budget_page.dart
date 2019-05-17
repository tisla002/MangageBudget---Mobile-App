import 'dart:ui';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'firebase.dart';
import 'login_page.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import "creditsAndExpenses.dart";
//import 'package:flutter_sidekick/flutter_sidekick.dart';

final budgetBoxHeight = 30.0;
final budgetBoxWidth = 400.0;
final numCount = 10;
String _total_budget = "";
String _new_category = "";
String _color_selected = "";

TextEditingController amount = new TextEditingController();
TextEditingController category = new TextEditingController();

List<BudgetCategory> dataSample = [
  new BudgetCategory("Food", 500, 300, charts.MaterialPalette.green.shadeDefault),
  new BudgetCategory("Groceries", 500, 200, charts.MaterialPalette.blue.shadeDefault),
  new BudgetCategory("Potatoes", 600, 400, charts.MaterialPalette.pink.shadeDefault)
];

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


    sample.add( BudgetCategory( value["budget category"],value["cost"], totalBudgetExpense(value["budget category"]),
        charts.Color.fromHex( code: colorsForCharts[index]) ) );
  });

  print(budgetLimit2(userID));

  return sample;
}

class _expensesListViewState extends State<expensesListView>{
  List<BudgetCategory> targetList = sample();

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
                color: Colors.green,
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
//                        onEditingComplete: (value) _new_category = value,
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
                          addBudget(userID, int.parse(amount.text), category.text, _color_selected);
                            buttonPressed(context); //dummy onPressed does not look at the value
                          }
                        },
                        child: Text('Enter'),
                      ),
                      new Container(
                        height: 300,
                        child: BudgetColorChoices(),
                      )
                    ])
                ),
            ),
        );
  }
}

class BudgetColorChoices extends StatefulWidget {
  @override
  State<BudgetColorChoices> createState(){
    return _BudgetColorChoicesState();
  }
}

class _BudgetColorChoicesState extends State<BudgetColorChoices> {
  int addition = 3;
  bool _tapInProgress = false;

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
              //_tapInProgress = !_tapInProgress;
              _color_selected = "blue";
            },
            onTapCancel: () {
              //_tapInProgress = false;
              _color_selected = "";
            },
            child: Container(
            alignment: Alignment.centerRight,
                height: 50.0, width: 50.0,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    )
                )
            ),
          ),
          GestureDetector(
            onTap: () {
              _color_selected = "red";
            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                )
              )
            ),
          ),
          GestureDetector(
            onTap: () {
              _color_selected = "green";
            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                )
              )
            ),
          ),
          GestureDetector(
            onTap: () {
              _color_selected = "yellow";
            },
            child: Container(
              alignment: Alignment.centerRight,
              height: 50.0, width: 50.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(
                  color: Colors.black,
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
                  _color_selected = "pink";
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  _color_selected = "lime";
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.lime,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  _color_selected = "teal";
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap: () {
                  _color_selected = "indigo";
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        border: Border.all(
                          color: Colors.black,
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

  /*Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: false,
        itemCount: colorPickerList.length ~/ 4,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) { //need to fix issue of overflow

            return Row(
            mainAxisSize: MainAxisSize.min,
//            verticalDirection: VerticalDirection.,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
               GestureDetector(
                    onTap: () {
                      buttonPressed(context);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: 50.0,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: colorPickerList.elementAt( (i * addition) + i + 0).dartColor,
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            )
                        )
                    ),
                  ),
              GestureDetector(
                onTap:( ) {
                  buttonPressed(context);
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: colorPickerList.elementAt( (i * addition) + i + 1 ).dartColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap:( ) {
                  buttonPressed(context);
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: colorPickerList.elementAt( (i * addition) + i + 2 ).dartColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
              GestureDetector(
                onTap:( ) {
                  buttonPressed(context);
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 50.0, width: 50.0,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: colorPickerList.elementAt( (i * addition) + i + 3 ).dartColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    )
                ),
              ),
            ],
          );
        }
    );

  }*/
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
  //print(budgetHistory(userID));


  return sampleTotal;
}





class _budgetExpensesListViewState extends State<budgetExpensesListView>{
  //List<expensesListEntry> targetList = expensesListEntrySample;
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