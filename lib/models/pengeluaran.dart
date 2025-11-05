import 'dart:convert'; // ignore_for_file: public_member_api_docs, sort_constructors_first

class PengeluaranModel {
  final int? id;
  final String notesPengeluaran;
  final String tanggalKeluar;
  final int jumlahPengeluaran;
  final String kategoriCatatan;
  final String kategoriPengeluaran;

  PengeluaranModel({
    this.id,
    required this.notesPengeluaran,
    required this.tanggalKeluar,
    required this.jumlahPengeluaran,
    required this.kategoriCatatan,
    required this.kategoriPengeluaran,
  });

  // Convert ke Map (untuk insert ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notesPengeluaran': notesPengeluaran,
      'tanggalKeluar': tanggalKeluar,
      'jumlahPengeluaran': jumlahPengeluaran,
      'kategoriCatatan': kategoriCatatan,
      'kategoriPengeluaran': kategoriPengeluaran,
    };
  }

  // Convert dari Map (saat ambil data dari database)
  factory PengeluaranModel.fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      id: map['id'] as int?,
      notesPengeluaran: map['notesPengeluaran'] as String,
      tanggalKeluar: (map['tanggalKeluar'] as String),
      jumlahPengeluaran: (map['jumlahPengeluaran'] as int),
      kategoriCatatan: map['kategoriCatatan'] as String,
      kategoriPengeluaran: map['kategoriPengeluaran'] as String,
    );
  }
}
