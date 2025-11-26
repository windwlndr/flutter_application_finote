// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanModelFirebase {
  final String? id;
  final String notesPemasukan;
  final String tanggalMasuk;
  final int jumlahPemasukan;
  final String kategoriCatatan;
  final String kategoriPemasukan;

  PemasukanModelFirebase({
    this.id,
    required this.notesPemasukan,
    required this.tanggalMasuk,
    required this.jumlahPemasukan,
    required this.kategoriCatatan,
    required this.kategoriPemasukan,
  });

  // Convert ke Map (untuk insert ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notesPemasukan': notesPemasukan,
      'tanggalMasuk': tanggalMasuk,
      'jumlahPemasukan': jumlahPemasukan,
      'kategoriCatatan': kategoriCatatan,
      'kategoriPemasukan': kategoriPemasukan,
    };
  }

  // Convert dari Map (saat ambil data dari database)
  factory PemasukanModelFirebase.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PemasukanModelFirebase(
      id: doc.id,
      notesPemasukan: data["notesPemasukan"] ?? '',
      jumlahPemasukan: (data["jumlahPemasukan"] is int)
          ? data["jumlahPemasukan"]
          : int.tryParse((data["jumlahPemasukan"] ?? '0').toString()) ?? 0,
      tanggalMasuk: data["tanggalMasuk"] ?? '',
      kategoriCatatan: data["kategoriCatatan"] ?? '',
      kategoriPemasukan: data["kategoriPemasukan"] ?? '',
    );
  }
}
