// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  factory PemasukanModelFirebase.fromMap(Map<String, dynamic> map) {
    return PemasukanModelFirebase(
      id: map['id'] as String?,
      notesPemasukan: map['notesPemasukan'] as String,
      tanggalMasuk: (map['tanggalMasuk'] as String),
      jumlahPemasukan: (map['jumlahPemasukan'] as int),
      kategoriCatatan: map['kategoriCatatan'] as String,
      kategoriPemasukan: map['kategoriPemasukan'] as String,
    );
  }
}
