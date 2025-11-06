import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const tableUser = 'users';
  static const tablePengeluaran = 'pengeluaran';
  static const tablePemasukan = 'pemasukan';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'finote.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)",
        );
        await db.execute(
          "CREATE TABLE $tablePengeluaran(id INTEGER PRIMARY KEY AUTOINCREMENT, notesPengeluaran TEXT, tanggalKeluar TEXT, jumlahPengeluaran INTEGER, kategoriCatatan TEXT, kategoriPengeluaran TEXT)",
        );

        await db.execute(
          "CREATE TABLE $tablePemasukan(id INTEGER PRIMARY KEY AUTOINCREMENT, notesPemasukan TEXT, tanggalMasuk TEXT, jumlahPemasukan INTEGER, kategoriCatatan TEXT, kategoriPemasukan TEXT)",
        );
      },

      version: 7,
    );
  }

  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  static Future<UserModel?> loginUser({
    //required String name,
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    //query adalah fungsi untuk menampilkan data (READ)
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // GET USER BY ID
  static Future<UserModel?> getUserById(int id) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  //GET USER
  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  //UPDATE
  static Future<void> updateUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tableUser,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  //DELETE
  static Future<void> deleteUser(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(tableUser, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> insertPengeluaran(PengeluaranModel pengeluaran) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tablePengeluaran,
      pengeluaran.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(pengeluaran.toMap());
  }

  static Future<List<PengeluaranModel>> getAllPengeluaran() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tablePengeluaran,
    );
    print(results.map((e) => PengeluaranModel.fromMap(e)).toList());
    return results.map((e) => PengeluaranModel.fromMap(e)).toList();
  }

  static Future<List<PengeluaranModel>> getPengeluaranByKategori(
    String kategori,
  ) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tablePengeluaran,
      where: 'kategoriPengeluaran = ?',
      whereArgs: [kategori],
    );
    return results.map((e) => PengeluaranModel.fromMap(e)).toList();
  }

  static Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async {
    final dbs = await db();
    await dbs.update(
      tablePengeluaran,
      pengeluaran.toMap(),
      where: 'id = ?',
      whereArgs: [pengeluaran.id],
    );
  }

  static Future<void> deletePengeluaran(int id) async {
    final dbs = await db();
    await dbs.delete(tablePengeluaran, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertPemasukan(PemasukanModel pemasukan) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tablePemasukan,
      pemasukan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(pemasukan.toMap());
  }

  static Future<List<PemasukanModel>> getAllPemasukan() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tablePemasukan);
    print(results.map((e) => PemasukanModel.fromMap(e)).toList());
    return results.map((e) => PemasukanModel.fromMap(e)).toList();
  }

  static Future<List<PemasukanModel>> getPemasukanByKategori(
    String kategori,
  ) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tablePemasukan,
      where: 'kategoriPemasukan = ?',
      whereArgs: [kategori],
    );
    return results.map((e) => PemasukanModel.fromMap(e)).toList();
  }

  static Future<void> updatePemasukan(PemasukanModel pemasukan) async {
    final dbs = await db();
    await dbs.update(
      tablePemasukan,
      pemasukan.toMap(),
      where: 'id = ?',
      whereArgs: [pemasukan.id],
    );
  }

  static Future<void> deletePemasukan(int id) async {
    final dbs = await db();
    await dbs.delete(tablePemasukan, where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, double>> getTotalPengeluaranPerKategori() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.rawQuery('''
    SELECT kategoriPengeluaran, SUM(jumlahPengeluaran) as total
    FROM $tablePengeluaran
    GROUP BY kategoriPengeluaran
  ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['kategoriPengeluaran']] = (row['total'] as num).toDouble();
    }
    return data;
  }

  static Future<Map<String, double>> getTotalPengeluaranPerTanggal() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.rawQuery('''
    SELECT tanggalKeluar, SUM(jumlahPengeluaran) as total
    FROM $tablePengeluaran
    GROUP BY tanggalKeluar
    ORDER BY tanggalKeluar ASC
  ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['tanggalKeluar']] = (row['total'] as num).toDouble();
    }
    return data;
  }

  static Future<Map<String, double>> getTotalPemasukanPerKategori() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.rawQuery('''
    SELECT kategoriPemasukan, SUM(jumlahPemasukan) as total
    FROM $tablePemasukan
    GROUP BY kategoriPemasukan
  ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['kategoriPemasukan']] = (row['total'] == null)
          ? 0.0
          : (row['total'] as num).toDouble();
    }
    return data;
  }

  static Future<Map<String, double>> getTotalPemasukanPerTanggal() async {
    final dbs = await db();
    final List<Map<String, dynamic>> result = await dbs.rawQuery('''
    SELECT tanggalMasuk, SUM(jumlahPemasukan) as total
    FROM $tablePemasukan
    GROUP BY tanggalMasuk
    ORDER BY tanggalMasuk ASC
  ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['tanggalMasuk']] = (row['total'] as num).toDouble();
    }
    return data;
  }

  // GET BY EMAIL
  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await DbHelper.db();
    final List<Map<String, dynamic>> maps = await db.query(
      tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<Map<String, double>> getTotalPengeluaranPerPeriode(
    String mode,
  ) async {
    final dbs = await db();
    String query = '';

    if (mode == 'Mingguan') {
      // Total pengeluaran per hari selama 7 hari terakhir
      query =
          '''
      SELECT strftime('%w', tanggalKeluar) AS hari, SUM(jumlahPengeluaran) AS total
      FROM $tablePengeluaran
      WHERE date(tanggalKeluar) >= date('now', '-6 days')
      GROUP BY hari
      ORDER BY hari;
    ''';
    } else if (mode == 'Bulanan') {
      // Total pengeluaran per minggu (4 minggu terakhir)
      query =
          '''
      SELECT strftime('%W', tanggalKeluar) AS minggu, SUM(jumlahPengeluaran) AS total
      FROM $tablePengeluaran
      WHERE date(tanggalKeluar) >= date('now', '-30 days')
      GROUP BY minggu
      ORDER BY minggu;
    ''';
    } else if (mode == 'Tahunan') {
      // Total pengeluaran per bulan (12 bulan terakhir)
      query =
          '''
      SELECT strftime('%m', tanggalKeluar) AS bulan, SUM(jumlahPengeluaran) AS total
      FROM $tablePengeluaran
      WHERE date(tanggalKeluar) >= date('now', '-12 months')
      GROUP BY bulan
      ORDER BY bulan;
    ''';
    }

    final result = await dbs.rawQuery(query);

    Map<String, double> data = {};
    for (var row in result) {
      final key = row.values.first.toString();
      final val = (row['total'] == null)
          ? 0.0
          : (row['total'] as num).toDouble();
      data[key] = val;
    }

    return data;
  }
}
