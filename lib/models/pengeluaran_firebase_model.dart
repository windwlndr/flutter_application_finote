class PengeluaranModelFirebase {
  final String? id;
  final String notesPengeluaran;
  final int jumlahPengeluaran;
  final String tanggalKeluar;
  final String kategoriCatatan;
  final String kategoriPengeluaran;

  PengeluaranModelFirebase({
    this.id,
    required this.notesPengeluaran,
    required this.jumlahPengeluaran,
    required this.tanggalKeluar,
    required this.kategoriCatatan,
    required this.kategoriPengeluaran,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "notesPengeluaran": notesPengeluaran,
    "jumlahPengeluaran": jumlahPengeluaran,
    "tanggalKeluar": tanggalKeluar,
    "kategoriCatatan": kategoriCatatan,
    "kategoriPengeluaran": kategoriPengeluaran,
  };

  factory PengeluaranModelFirebase.fromMap(Map<String, dynamic> map) =>
      PengeluaranModelFirebase(
        id: map["id"],
        notesPengeluaran: map["notesPengeluaran"],
        jumlahPengeluaran: map["jumlahPengeluaran"],
        tanggalKeluar: map["tanggalKeluar"],
        kategoriCatatan: map["kategoriCatatan"],
        kategoriPengeluaran: map["kategoriPengeluaran"],
      );
}
