import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModelFirebase {
  String id;
  String kategori;
  double targetValue;

  BudgetModelFirebase({
    required this.id,
    required this.kategori,
    required this.targetValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'targetValue': targetValue,
    };
  }

  factory BudgetModelFirebase.fromDoc(DocumentSnapshot doc) {
    return BudgetModelFirebase(
      id: doc.id,
      kategori: doc['kategori'],
      targetValue: doc['targetValue'].toDouble(),
    );
  }
}
