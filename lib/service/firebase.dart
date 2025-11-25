import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_finote/models/pemasukan_firebase_model.dart';
import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/models/pengeluaran_firebase_model.dart';
import 'package:flutter_application_finote/models/user_firebase_model.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<UserFirebaseModel> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user!;
    final model = UserFirebaseModel(
      uid: user.uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );
    await firestore.collection('users').doc(user.uid).set(model.toMap());
    return model;
  }

  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user == null) return null;
    final snap = await firestore.collection('users').doc(user.uid).get();
    if (!snap.exists) return null;
    return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
  }

  static Future<UserFirebaseModel?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;

    final snap = await firestore.collection('users').doc(user.uid).get();

    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
  }
  
  static Future<void> updateUser({
  required String uid,
  required String username,
  required String email,
}) async {
  await firestore.collection('users').doc(uid).update({
    'username': username,
    'email': email,
    'updateAt': DateTime.now().toIso8601String(),
  });

  // update email di Firebase Auth kalau email berubah
  final userAuth = auth.currentUser;
  if (userAuth != null && userAuth.email != email) {
    await userAuth.verifyBeforeUpdateEmail(email);
  }
}

// -------------------- PENGELUARAN --------------------

static Future<void> insertPengeluaran(String uid, PengeluaranModelFirebase data) async {
  final doc = firestore
      .collection('users')
      .doc(uid)
      .collection('pengeluaran')
      .doc();

  await doc.set({
    "id": doc.id,
    ...data.toMap(),
  });
}

static Future<void> updatePengeluaran(String uid, PengeluaranModelFirebase data) async {
  await firestore
      .collection('users')
      .doc(uid)
      .collection('pengeluaran')
      .doc(data.id)
      .update(data.toMap());
}

static Future<void> deletePengeluaran(String uid, String id) async {
  await firestore
      .collection('users')
      .doc(uid)
      .collection('pengeluaran')
      .doc(id)
      .delete();
}

static Future<List<PengeluaranModelFirebase>> getAllPengeluaran(String uid) async {
  final snap = await firestore
      .collection('users')
      .doc(uid)
      .collection('pengeluaran')
      .orderBy('tanggalKeluar', descending: true)
      .get();

  return snap.docs.map((e) => PengeluaranModelFirebase.fromMap(e.data())).toList();
}

// -------------------- PEMASUKAN --------------------

static Future<void> insertPemasukan(String uid, PemasukanModelFirebase data) async {
  final doc = firestore
      .collection('users')
      .doc(uid)
      .collection('pemasukan')
      .doc();

  await doc.set({
    "id": doc.id,
    ...data.toMap(),
  });
}

static Future<void> updatePemasukan(String uid, PemasukanModelFirebase data) async {
  await firestore
      .collection('users')
      .doc(uid)
      .collection('pemasukan')
      .doc(data.id)
      .update(data.toMap());
}

static Future<void> deletePemasukan(String uid, String id) async {
  await firestore
      .collection('users')
      .doc(uid)
      .collection('pemasukan')
      .doc(id)
      .delete();
}

static Future<List<PemasukanModelFirebase>> getAllPemasukan(String uid) async {
  final snap = await firestore
      .collection('users')
      .doc(uid)
      .collection('pemasukan')
      .orderBy('tanggalMasuk', descending: true)
      .get();

  return snap.docs.map((e) => PemasukanModelFirebase.fromMap(e.data())).toList();
}

}
