import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
//import 'main_page.dart';

//void main() => runApp(BudgetPage());

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BudgetPageState();//_BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final noOfSelectedItems = 0;
  final _medFont = const TextStyle(fontSize: 20.0);
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: new Color(0xFF18D191),
              title: Text('BudgetPage', style: _medFont)
            ),
            body: _buildSuggestions(),
            floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: new Color(0xFF18D191), //color....
              onPressed: () { Navigator.of(context).pushNamed("/AddBudgetPage");}
            )
          );
        }
        Widget _buildSuggestions() {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
                itemCount: 2,
                itemBuilder: (context, i) {
                  if (noOfSelectedItems > 0) {    //I want it so that at the base it has total money spent and their budget
                    if (i.isOdd) return Divider();
                    //final index = i ~/ 2;
                    return _buildRow();
                    }
                  else {
                       //I want it so that at the base it has total money spent and their budget
                      if (i.isOdd) return Divider();
                      //final index = i ~/ 2;
                      return _buildBasicRow();
                  }
                }

          );
        }

        Widget _buildRow() {
           return ListTile(
                //leading: Icon(),
                title: Text('words go here'),
                subtitle: Text('subwords go here'),
                onTap: () {/*React to being tapped*/ },
           );
        }

        Widget _buildBasicRow() {
           return ListTile(
             title: Text('Total Budget'),
             onTap: () { },
           );
        }
}

class BudgetCategories extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
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
                      new TextField(),
                      new RaisedButton(
                        onPressed: () { null; },
                        child: Text('Enter'),
                      ),
                    ]
                )
            )
        )

    );
  }
}
/*
class AddBudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Add'),
      )
    );
  }
}*/

void buttonPressed(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("You have pressed a button successfully"),
    content: Text("Thank you for pressing me"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    }
  );
}


