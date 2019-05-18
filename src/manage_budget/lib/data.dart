import 'dart:core';
import 'package:manage_budget/firebase.dart';
import 'package:manage_budget/login_page.dart';

//userID
int dontRunThis = 0;
Map<String, int> approachingLimit = new Map();
List<dynamic> budgetList = new List();
List<String> categories = new List();
Map<String, double> budgetsMax = new Map();
Map<String, double> budgetSpent = new Map();

void updateData(){
    print("expense updated");
  if(userID == ""){
    return;
  }
  budgetList = budgetLimit2(userID);
  budgetList.forEach((item){
    if(!(categories.contains(item["budget category"]))){
      categories.add(item["budget category"]);
      budgetsMax[item["budget category"]] = item["cost"]; 
    }
    budgetSpent.clear();
    if(budgetSpent.containsKey(item["budget category"])){
      budgetSpent[item["budget category"]] += item["cost"];
    }else{
      budgetSpent[item["budget category"]] = 0;
    }
  });
  budgetSpent.forEach((key, value){
    if(value/budgetsMax[key] >= .8){
      approachingLimit[key] = (double.parse((value/budgetsMax[key]).toStringAsFixed(2)) * 100).toInt();
    }
  }); 
}

//Could add the if statement...or you could only just call this function once
void initMaps(){
  if(budgetList == null || dontRunThis == 1 || userID == ""){
    return;
  }
  dontRunThis = 1;
  print("CALLED");
  budgetList = budgetLimit2(userID);
  print(budgetList);
  budgetList.forEach((item){
    print(item["budget category"]);
    categories.add(item["budget category"]);
    budgetsMax[item["budget category"]] = item["cost"];  
    budgetSpent[item["budget category"]] = 0;
  });

  //budgetSpent.forEach((cat, cost)
  //for(int i = 0; i < budgetSpent.length; i++){
  //  print(categories[i];
budgetHistory2(userID, "Candy").forEach((val){//FIX budget history to only return relevant data?
      budgetSpent[val["budget category"]] += val["cost"];
    });
    print("end cat");
  //}
  print("^budget spent");
  print(budgetSpent);
  print(budgetsMax);
  print("^Maxes");

}

