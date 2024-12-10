import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
initializeApp() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDaYezar8WW4kVYDut3kNTIiM-y_CNJhmk",
          authDomain: "itcs444-92e3f.firebaseapp.com",
          projectId: "itcs444-92e3f",
          storageBucket: "itcs444-92e3f.firebasestorage.app",
          messagingSenderId: "293487894537",
          appId: "1:293487894537:web:cb807b4e0a669e098bd8d8"));
}

Future<void> addExam(data, String? id) async {
  if (id == null) {
    final creation = db.collection("exams").doc();
    data["EID"] = creation.id;
    await creation.set(data);
  } else {
    data["EID"] = id;
    await db.collection("exams").doc(id).set(data);
  }
  return;
}

Future<int?> getResponseCount(String id) async {
  final count = await db
      .collection("exams")
      .doc(id)
      .collection("responses")
      .count()
      .get();
  return count.count;
}

Future<void> deleteExam(String id) async {
  await db.collection("exams").doc(id).delete();
}

Future<void> updateGrades(String examId, String responseId, data) async {
  await db
      .collection("exams")
      .doc(examId)
      .collection("responses")
      .doc(responseId)
      .set(data);
}

Stream<List<Map<String, dynamic>>> getExamsByID(String id) {
  final data = db
      .collection("exams")
      .where("uid", isEqualTo: id)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {...doc.data()}).toList());
  return data;
}

Future<List<Map<String, dynamic>>> getUserbyID(String id) async {
  final data = await db.collection("users").where("uid", isEqualTo: id).get();
  List<Map<String, dynamic>> list = [];
  data.docs.forEach((element) {
    list.add(element.data());
  });
  return list;
}

Stream<List<Map<String, dynamic>>> getResponses(String id) {
  final data = db
      .collection("exams")
      .doc(id)
      .collection("responses")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => {...doc.data()}).toList());
  return data;
}

Stream<List<Map<String, dynamic>>> getStudentExamById(String id) {
  return db.collection("exams").snapshots().asyncMap((snapshot) async {
    List<Map<String, dynamic>> list = [];
    for (var doc in snapshot.docs) {
      final responses = await doc.reference
          .collection("responses")
          .where("uid", isEqualTo: id)
          .get();

      if (responses.size > 0) {
        list.add(doc.data());
      }
    }
    return list;
  });
}

Future<List<Map<String, dynamic>>> getStudentResponseById(
    String EID, String uid) async {
  final data = await db
      .collection("exams")
      .doc(EID)
      .collection("responses")
      .where("uid", isEqualTo: uid)
      .get();
  List<Map<String, dynamic>> list = [];
  data.docs.forEach((element) {
    list.add(element.data());
  });
  return list;
}
