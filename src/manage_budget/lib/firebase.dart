  import 'package:firebase_database/firebase_database.dart';

  List<dynamic> _list = new List();
  int _dataInt = 0;

  List<dynamic> getDataList(DatabaseReference ref, String dataToGet){

    ref.once().then((val){
      //print('Data : ${val.value["total credit"]}');
      _list = val.value[dataToGet];
    } );

    return _list;
  }

  int getDataInt(DatabaseReference ref, String dataToGet){

    ref.child(dataToGet).once().then((val){
      print('Data : ${val.value[dataToGet]}');
      _dataInt = val.value[dataToGet];
    } );

    return _dataInt;
  }

  void newuser(String uid){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(uid);

    user.set({
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

  bool addCredit (String userID, int amount, String date){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);
    
    user.child("Credits").push().set({
      "description" : ".....",
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

  bool addBudget(String userID, int amount, String category){
    DatabaseReference user = FirebaseDatabase.instance.reference().child("UserData").child(userID);

    user.child("Budgets").push().set({
      "budget category" : category,
      "cost" : amount
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

