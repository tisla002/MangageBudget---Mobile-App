import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:manage_budget/login_page.dart";
import "package:manage_budget/settings.dart";
import 'package:firebase_database/firebase_database.dart';
import "package:manage_budget/creditsAndExpenses.dart";
import "budget_page.dart";
import "package:manage_budget/firebase.dart";

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class Dropdown extends StatefulWidget {

  @override
  _DropdownState createState() => new _DropdownState();
}

class _DropdownState extends State<Dropdown>{

  TextEditingController addExpensesController = new TextEditingController();
  TextEditingController addDescriptionController = new TextEditingController();
  dynamic dropdownValue;
  List<String>generateStringList(){
    List<String> targetList=[];
    List<dynamic> grabbedList= budgetLimit2(returnUserID());
        grabbedList.forEach((category){
          targetList.add(category["budget category"]);
        }
    );
    return targetList;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 320,
          child: GaugeChart(createData(creditsAndExpensesSample())),
        ),
        Container(
          height: 232,
          child:
              tableOfContents(),
        ),
        Card(
            child:
            ButtonTheme(
              minWidth: 400.0,
              height: 76.0,
              child: RaisedButton(
                onPressed: () {
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          elevation: 15,
                          content: Container(
                              height: 182,
                              child:
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    child:
                                    new TextField(
                                      decoration: new InputDecoration(labelText: "Enter your number"),
                                      controller: addExpensesController,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                    ),
                                  ),
                                  Container(
                                      height: 50,
                                      child:
                                      new TextField(
                                        decoration: new InputDecoration(labelText: "Enter your description"),
                                        controller: addDescriptionController,
                                      )
                                  ),
                                  new FormField(builder: (FormFieldState state){
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.assignment),
                                        labelText: 'Budget Category',
                                      ),
                                      child:  new DropdownButtonHideUnderline(
                                          child: new DropdownButton<dynamic>(
                                            value: dropdownValue,
                                            isDense: true,
                                            onChanged: (dynamic newValue){
                                              setState( (){
                                                dropdownValue = newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: generateStringList().map((String value){
                                              return new DropdownMenuItem<String>(
                                                  value: value,
                                                  child: new Text(value)
                                              );
                                            }).toList(),
                                          )
                                      ),
                                    );

                                  })
                                ],
                              )
                          ),
                          actions: <Widget>[
                            ButtonTheme(
                              minWidth:125,
                              child:
                              new RaisedButton.icon(
                                  icon: new Icon(Icons.check,color: Colors.white),
                                  disabledColor: Colors.grey,
                                  color: Colors.green,
                                  onPressed: () {
                                    addExpense(returnUserID(), int.parse(addExpensesController.text), "4/20/2019", dropdownValue, addDescriptionController.text);
                                    Navigator.of(context).pop();
                                  },
                                  label: Text("")
                              ),
                            ),

                            ButtonTheme(
                              minWidth:125,
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
                child: Column(
                  children: <Widget>[
                    Icon(Icons.attach_money,color: Colors.white,size: 60),
                    Text ("Add Expenses",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            )
        )
      ],
    );
  }
}


class tableOfContents extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    List<budgetColorEntry> targetList = grabBudgetList();
    return Column(
      children: <Widget>[
        Card(
          color: Colors.green,
          child: Container(
            padding: EdgeInsets.only(left:10),
            width: MediaQuery.of(context).size.width,
            child:Text("Total Expenses: "+ "\$"+creditTotal(creditsAndExpensesSample()).toString(),style:new TextStyle(fontSize:30,color:Colors.white))
          )
        ),
        Container(
          height:188,
          child: ListView.builder(itemCount: targetList.length,itemBuilder:(context,index){
            return ListTile(
              title: Text(targetList.elementAt(index).budgetName,style:new TextStyle(fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.monetization_on,color:colorPicker(targetList.elementAt(index).color).dartColor,size: 30,),
            );
          }),
        )
      ],
    );
  }
  double creditTotal(List<expensesListEntry> creditList){
    double sum = 0.0;
    for(int i=0;i<creditList.length;i++){
      sum = sum+creditList[i].amount;
    }
    return sum;
  }
  List<budgetColorEntry> grabBudgetList(){
    List<budgetColorEntry> colorList = new List();
    budgetLimit2(returnUserID()).forEach((key){
      colorList.add(budgetColorEntry(key["budget category"], key["color"]));
    });

    return colorList;
  }

}

class _MainPageState extends State<MainPage> {


  @override
  void initState(){
    super.initState();
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
        Dropdown(),
        creditsAndExpensesPage(),
        BudgetPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget App"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              FirebaseAuth.instance.signOut().then((value){
                connect = false;
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                //return new LoginPage();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Overview"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.attach_money),
            title: new Text("Credits/Expenses"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.insert_chart),
            title: new Text("Budgets"),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}