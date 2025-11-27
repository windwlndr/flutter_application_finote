class RencanaBulananModelFirebase {
  final String id;
  final String uid;
  final String rencana;
  final int harga;
  final bool selesai;
  final String createdAt;

  RencanaBulananModelFirebase({
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

  factory RencanaBulananModelFirebase.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return RencanaBulananModelFirebase(
      id: id,
      uid: map['uid'],
      rencana: map['rencana'],
      harga: map['harga'],
      selesai: map['selesai'],
      createdAt: map['createdAt'],
    );
  }
}
