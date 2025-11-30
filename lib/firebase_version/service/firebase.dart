import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_finote/firebase_version/models/budget_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/models/monthly_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/models/pemasukan_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/models/pengeluaran_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/models/user_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/models/weekly_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/models/yearly_model_firebase.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //register
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

  //login
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

  //ambil data user
  static Future<UserFirebaseModel?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;

    final snap = await firestore.collection('users').doc(user.uid).get();

    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
  }

  //edit data username dan email
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

  //Logout
  static Future<void> logoutUser() async {
    await auth.signOut();
  }

  //PENGELUARAN
  static Future<void> insertPengeluaran(
    String uid,
    PengeluaranModelFirebase data,
  ) async {
    final doc = firestore
        .collection('users')
        .doc(uid)
        .collection('pengeluaran')
        .doc();

    await doc.set({"id": doc.id, ...data.toMap()});
  }

  static Future<void> updatePengeluaran(
    String uid,
    PengeluaranModelFirebase data,
  ) async {
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

  static Future<List<PengeluaranModelFirebase>> getAllPengeluaran(
    String uid,
  ) async {
    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('pengeluaran')
        .orderBy('tanggalKeluar', descending: true)
        .get();

    return snap.docs
        .map((doc) => PengeluaranModelFirebase.fromDoc(doc))
        .toList();

    // return snap.docs.map((doc) {
    //   return PengeluaranModelFirebase.fromMap({"id": doc.id, ...doc.data()});
    // }).toList();
  }

  //PEMASUKAN
  static Future<void> insertPemasukan(
    String uid,
    PemasukanModelFirebase data,
  ) async {
    final doc = firestore
        .collection('users')
        .doc(uid)
        .collection('pemasukan')
        .doc();

    await doc.set({"id": doc.id, ...data.toMap()});
  }

  static Future<void> updatePemasukan(
    String uid,
    PemasukanModelFirebase data,
  ) async {
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

  static Future<List<PemasukanModelFirebase>> getAllPemasukan(
    String uid,
  ) async {
    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('pemasukan')
        .orderBy('tanggalMasuk', descending: true)
        .get();

    return snap.docs.map((doc) => PemasukanModelFirebase.fromDoc(doc)).toList();
  }

  //weekly planning
  static Future<void> tambahRencanaMingguan({
    required String rencana,
    required int harga,
  }) async {
    final user = auth.currentUser!;
    final doc = firestore.collection('rencana_mingguan').doc();

    await doc.set({
      'uid': user.uid,
      'rencana': rencana,
      'harga': harga,
      'selesai': false,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<RencanaMingguanModelFirebase>> getRencanaMingguan() {
    final user = auth.currentUser!;
    return firestore
        .collection('rencana_mingguan')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) =>
                    RencanaMingguanModelFirebase.fromMap(doc.id, doc.data()),
              )
              .toList(),
        );
  }

  static Future<void> updateChecklist({
    required String id,
    required bool status,
  }) async {
    await firestore.collection('rencana_mingguan').doc(id).update({
      'selesai': status,
    });
  }

  static Future<void> hapusRencanaMingguan(String id) async {
    await firestore.collection('rencana_mingguan').doc(id).delete();
  }

  //monthly planning
  static Future<void> tambahRencanaBulanan({
    required String rencana,
    required int harga,
  }) async {
    final user = auth.currentUser!;
    final doc = firestore.collection('rencana_bulanan').doc();

    await doc.set({
      'uid': user.uid,
      'rencana': rencana,
      'harga': harga,
      'selesai': false,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<RencanaBulananModelFirebase>> getRencanaBulanan() {
    final user = auth.currentUser!;
    return firestore
        .collection('rencana_bulanan')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) =>
                    RencanaBulananModelFirebase.fromMap(doc.id, doc.data()),
              )
              .toList(),
        );
  }

  static Future<void> updateMonthChecklist({
    required String id,
    required bool status,
  }) async {
    await firestore.collection('rencana_bulanan').doc(id).update({
      'selesai': status,
    });
  }

  static Future<void> hapusRencanaBulanan(String id) async {
    await firestore.collection('rencana_bulanan').doc(id).delete();
  }

  //yearly planning
  static Future<void> tambahRencanaTahunan({
    required String rencana,
    required int harga,
  }) async {
    final user = auth.currentUser!;
    final doc = firestore.collection('rencana_tahunan').doc();

    await doc.set({
      'uid': user.uid,
      'rencana': rencana,
      'harga': harga,
      'selesai': false,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<RencanaTahunanModelFirebase>> getRencanaTahunan() {
    final user = auth.currentUser!;
    return firestore
        .collection('rencana_tahunan')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) =>
                    RencanaTahunanModelFirebase.fromMap(doc.id, doc.data()),
              )
              .toList(),
        );
  }

  static Future<void> updateYearChecklist({
    required String id,
    required bool status,
  }) async {
    await firestore.collection('rencana_tahunan').doc(id).update({
      'selesai': status,
    });
  }

  static Future<void> hapusRencanaTahunan(String id) async {
    await firestore.collection('rencana_tahunan').doc(id).delete();
  }
}

//manage budgeting
class BudgetService {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final budgetsRef = FirebaseFirestore.instance.collection("budgets");

  Stream<List<BudgetModelFirebase>> getBudgets() {
    return budgetsRef
        .doc(uid)
        .collection("kategoriBudget")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((d) => BudgetModelFirebase.fromDoc(d)).toList(),
        );
  }

  Future<void> saveBudget(String kategori, double targetValue) async {
    final doc = budgetsRef.doc(uid).collection("kategoriBudget").doc(kategori);
    await doc.set({"kategori": kategori, "targetValue": targetValue});
  }
}
