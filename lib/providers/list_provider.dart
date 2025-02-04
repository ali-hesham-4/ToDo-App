import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/Screens/list_tab/task_list_item.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasKList = [];
  DateTime selectedDate = DateTime.now();
  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollections(uId).get();
    tasKList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasKList = tasKList.where((task) {
      if (selectedDate.day == task.dateTime.day &&
          selectedDate.month == task.dateTime.month &&
          selectedDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();

    tasKList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectDate, String uId) {
    selectedDate = newSelectDate;
    getAllTasksFromFireStore(uId);
    notifyListeners();
  }
}
