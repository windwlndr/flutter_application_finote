class RencanaTahunanModelFirebase {
  final String id;
  final String uid;
  final String rencana;
  final int harga;
  final bool selesai;
  final String createdAt;

  RencanaTahunanModelFirebase({
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

  factory RencanaTahunanModelFirebase.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return RencanaTahunanModelFirebase(
      id: id,
      uid: map['uid'],
      rencana: map['rencana'],
      harga: map['harga'],
      selesai: map['selesai'],
      createdAt: map['createdAt'],
    );
  }
}
