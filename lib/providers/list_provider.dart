
import 'package:flutter/material.dart';
import 'package:todo_app_project/firebase_utils.dart';
import 'package:todo_app_project/model/task.dart';

class ListProvider extends ChangeNotifier{

  List<Task> taskList = [];
  var selectDate = DateTime.now();

 void getAllTasksFromFireStore(String uId)async{
    var querySnapshot = await FirebaseUtils.getTasksCollection(uId).get();
    taskList=querySnapshot.docs.map((doc){
      return doc.data();
    }).toList();

    taskList.sort((task1,task2){
     return task1.dateTime.compareTo(task2.dateTime);
    });

   taskList= taskList.where((task){
      if(selectDate.day == task.dateTime.day &&
      selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year){
        return true;
      }
      return false;
    }).toList();
    notifyListeners();
   }

   void changeSelectDate(DateTime newDate,String uId){
   selectDate = newDate;
   getAllTasksFromFireStore(uId);

   }

   void updateTaskInFireStore(Task task,String uId)async{
   await FirebaseUtils.updateTaskInFireStore(task,uId);
   getAllTasksFromFireStore(uId);
   }
  }
