  import 'package:firebase_database/firebase_database.dart';
  import 'dart:async';
  import 'package:manage_budget/data.dart';
  import 'package:manage_budget/notifications.dart';


  List<dynamic> _list = new List();
  List<dynamic> _search = new List();
  List<dynamic> _amnts = new List();
  List<dynamic> _grabHistory = new List();
  List<dynamic> _budgetHistory = new List();
  List<dynamic> _budgetHistory2 = new List();
  List<dynamic> _budgetLimit2 = new List();
  List<dynamic> _valuess = new List();
  int _dataInt = 0;
  int _budgetLimit = 0;

  List<dynamic> getDataList(DatabaseReference ref, String dataToGet){

    ref.once().then((val){
      //print('Data : ${val.value["total credit"]}');
      _list = val.value[dataToGet];
    } );

    return _list;
  }

  int getDataInt(DatabaseReference ref, String dataToGet){

    ref.child(dataToGet).once().then((val){
      //print('Data : ${val.value[dataToGet]}');
      _dataInt = val.value[dataToGet];
    } );

    return _dataInt;
  }

  List<dynamic> search(DatabaseReference ref, String searching, String category){

    ref.orderByChild(searching).equalTo(category).once().then((val){
      _search = val.value[""];
    });

    return _search;
  }

  void newuser(String uid){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(uid);

    user.update({
      //'userid' : uid,
      /*'credits' : {

      },
      'expenses' : {

      },
      'budgets' : {

      },*/
      'total credit' : {
        'total credit' : 0
      }
    });
  }

  bool addCredit (String userID, int amount, String date, String description){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);
    
    user.child("Credits").push().set({
      "description" : description,
      "amount" : amount,
      "date" : date
    });

    _updateCredit(user,amount);
    return true;
  }

  bool addExpense(String userID, int amount, String date, String category, String description){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);

    user.child("Expenses").push().set({
      "budget category" : category,
      "expense description" : description,
      "cost" : amount,
      "date" : date
    });
    
    return true;
  }

  bool addBudget(String userID, int amount, String category, String color){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);

    user.child("Budgets").push().set({
      "budget category" : category,
      "cost" : amount,
      "color" : color
    });

    _updateBudgetCategories(user, category);
    return true;

  }

  void _updateCredit(DatabaseReference user, int creditAmount){
    user.child("total credit").set({
        'total credit' : getDataInt(user, "total credit") + creditAmount
    });
  }

  void _updateBudgetCategories(DatabaseReference user, String category){
    List<dynamic> up = new List();
    up.add(category);

    user.update({
      'budgetlist' : getDataList(user, "budgetlist") + up
    });
  }

  List<dynamic> returnBudgetList(String userID){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);

    return getDataList(user, "budgetlist");
  }

  List<dynamic> grabHistory(String userID){ //gets all within credits
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID).child("Credits");

    /*
    user.once().then((value){
      _grabHistory = _parsing(value);
      //print(_grabHistory);
    });
    */

    grabHistoryStream(userID, user);
    
    //print(_grabHistory);
    return _grabHistory;
  }

  Future<StreamSubscription<Event>> grabHistoryStream(String userID, DatabaseReference ref) async {

    StreamSubscription<Event> subscription = ref.onValue.listen((Event event) {
      DataSnapshot val = event.snapshot;
      _grabHistory = _parsing(val);
    });

    return subscription;
  }

  List<dynamic> grabHistory2(String userID, String description) { //search by category
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID).child("Credits");

    /*
    user.orderByChild("description").equalTo(description).once().then((val){
      _amnts = _parsing(val);
      //print(_amnts);
    });
    */
    grabHistory2Stream(userID, user);

    //print(_amnts);
    return _amnts;
  }

  Future<StreamSubscription<Event>> grabHistory2Stream(String userID, DatabaseReference ref) async {

    StreamSubscription<Event> subscription = ref.onValue.listen((Event event) {
      DataSnapshot val = event.snapshot;
      _amnts = _parsing(val);
    });

    return subscription;
  }

  int budgetLimit(String userID, String category){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID).child("Budgets");
    List<dynamic> budgetList = new List();

    user.orderByChild("budget category").equalTo(category).once().then((val){
      budgetList = _parsingBudget(val);
      _budgetLimit = budgetList[0]["cost"];
    });

    return _budgetLimit;
  }

  List<dynamic> budgetLimit2(String userID){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID).child("Budgets");
    /*
    user.once().then((value){
      _budgetLimit2 = _parsingBudget(value);
      //print(expenseList);
    });
    */
    budgetlimit2Stream(userID,user);
    //print(_budgetHistory);
    return _budgetLimit2;
  }

  Future<StreamSubscription<Event>> budgetlimit2Stream(String userID, DatabaseReference ref) async {

    StreamSubscription<Event> subscription = ref.onValue.listen((Event event) {
      DataSnapshot val = event.snapshot;
      _budgetLimit2 = _parsingBudget(val);
    });

    return subscription;
  }

  List<dynamic> budgetHistory(String userID){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID).child("Expenses");

    Future.wait([budgetHistoryStream(userID, user)]);
    return _budgetHistory;
  }

  Future<StreamSubscription<Event>> budgetHistoryStream(String userID, DatabaseReference ref) async {

    StreamSubscription<Event> subscription = ref.onValue.listen((Event event) {
      DataSnapshot val = event.snapshot;
      _budgetHistory = _parsingBudget(val);
    });

    return subscription;
  }

  List<dynamic> budgetHistory2(String userID, String category){
    Query user = FirebaseDatabase
        .instance
        .reference()
        .child("UserData")
        .child(userID)
        .child("Expenses")
        .orderByChild("budget category")
        .equalTo(category);

    budgetHistory2Stream(userID, user);

    /*
    user.orderByChild("budget category").equalTo(category).once().then((value){
      _budgetHistory2 = _parsingBudget(value);

      //print(_budgetHistory);

    });*/

    return _budgetHistory2;
  }

  Future<StreamSubscription<Event>> budgetHistory2Stream(String userID, Query ref) async {

    StreamSubscription<Event> subscription = ref.reference().onValue.listen((Event event) {
      DataSnapshot val = event.snapshot;
      _budgetHistory2 = _parsingBudget(val);
    });

    return subscription;
  }

  List<dynamic> _parsing(DataSnapshot snap) {
    List<dynamic> creditList = new List();

    var map = Map.from(snap.value);

    map.values.forEach((value){
      creditList.add(value);
    });

    return creditList;
  }

  List<dynamic> _parsingBudget(DataSnapshot snap) {
    List<dynamic> budgetList = new List();

    var map = Map.from(snap.value);

    map.values.forEach((value){
      budgetList.add(value);
    });

    return budgetList;
  }


  class FirebaseStream {

    static Future<StreamSubscription<Event>> getStream(String userID,
        void onData(List<dynamic> budgetHistory)) async {

      StreamSubscription<Event> subscription = FirebaseDatabase
          .instance
          .reference()
          .child("UserData")
          .child(userID)
          //.child("Expenses")
          //.onValue
          .onChildChanged
          .listen((Event event) {
        DataSnapshot val = event.snapshot;
        _valuess = _parsingBudget(val);
        onData(_valuess);
      });

      return subscription;
    }

  }

  class Budget{
    String key;
    int budgetCategory;
    String cost;

    Budget(this.budgetCategory, this.cost);

    Budget.fromSnapshot(DataSnapshot snapshot) :
          key = snapshot.key,
          budgetCategory = snapshot.value["budget category"],
          cost = snapshot.value["cost"];

    toJson(){
      return {
        "budget category" : budgetCategory,
        "cost" : cost
      };
    }

  }

  class Expense{
    String key;
    int budgetCategory;
    String expenseDescription;
    int cost;
    String date;

    Expense(this.budgetCategory, this.expenseDescription, this.cost, this.date);

    Expense.fromSnapshot(DataSnapshot snapshot) :
          key = snapshot.key,
          budgetCategory = snapshot.value["budget category"],
          expenseDescription = snapshot.value["expense description"],
          cost = snapshot.value["cost"],
          date = snapshot.value["date"];

    toJson(){
      return {
        "budget category" : budgetCategory,
        "expense description" : expenseDescription,
        "cost" : cost,
        "date" : date
      };
    }

  }

  class Credit{
    String key;
    int amount;
    String date;
    String description;

    Credit(this.amount, this.date, this.description);

    Credit.fromSnapshot(DataSnapshot snapshot) :
          key = snapshot.key,
          amount = snapshot.value["amount"],
          date = snapshot.value["date"],
          description = snapshot.value["description"];

    toJson(){
      return {
        "amount" : amount,
        "date" : date,
        "description" : description
      };
    }
  }