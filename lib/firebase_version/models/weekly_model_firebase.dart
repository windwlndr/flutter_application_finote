class RencanaMingguanModelFirebase {
  final String id;
  final String uid;
  final String rencana;
  final int harga;
  final bool selesai;
  final String createdAt;

  RencanaMingguanModelFirebase({
    required this.id,
    required this.uid,
    required this.rencana,
    required this.harga,
    required this.selesai,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'rencana': rencana,
      'harga': harga,
      'selesai': selesai,
      'createdAt': createdAt,
    };
  }

  factory RencanaMingguanModelFirebase.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return RencanaMingguanModelFirebase(
      id: id,
      uid: map['uid'],
      rencana: map['rencana'],
      harga: map['harga'],
      selesai: map['selesai'],
      createdAt: map['createdAt'],
    );
  }
}
