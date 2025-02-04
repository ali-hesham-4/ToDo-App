import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_application/model/myUser.dart';
import 'package:to_do_application/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollections(String uId) {
    return getUserCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (Snapshot, options) =>
                Task.fromFireStore(Snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollections(uId);
    DocumentReference<Task> taskDocumentRefrance = taskCollection.doc();
    task.id = taskDocumentRefrance.id;
    return taskDocumentRefrance.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollections(uId).doc(task.id).delete();
  }

  static Future<void> editTask(Task task, String uId) {
    return getTasksCollections(uId).doc(task.id).update(task.toFireStore());
  }

  static Future<void> changeTaskStateFromFireStore(Task task, String uId) {
    return getTasksCollections(uId).doc(task.id).update({'isDone': true});
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: ((Snapshot, options) =>
                MyUser.fromFireStore(Snapshot.data())),
            toFirestore: (myUser, options) => myUser.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readFromFireStore(String uId) async {
    var querySnapShot = await getUserCollection().doc(uId).get();
    return querySnapShot.data();
  }
}
