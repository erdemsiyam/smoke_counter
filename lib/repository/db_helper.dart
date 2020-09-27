import 'dart:io';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";

class DatabaseHelper {
  /* Singleton */
  DatabaseHelper._internal();
  static DatabaseHelper _databaseHelper;
  factory DatabaseHelper() {
    if (_databaseHelper == null) // boşsa oluştur
      _databaseHelper = DatabaseHelper._internal();
    return _databaseHelper;
  }

  /* Get DB, create if is not exists */
  static Database _database;
  static Future<Database> getDatabase() async {
    if (_database == null)
      _database = await DatabaseHelper()._initializeDatabase();
    return _database;
  }

  _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String path = join(klasor.path, "assets/smoke_counter.db");
    var smokeDB = await openDatabase(path,
        version: 1, // migration version
        onCreate: _createDB // db oluşurken çalışacak fonksiyon istedi verdik
        );
    return smokeDB;
  }

  //yukarda initializde db oluşurkenki fonksiyonu yazarız
  static final String tableSmoke = "smoke";
  static final String columnId = "id";
  static final String columnDatetime = "datetime";
  static final String columnStress = "stress";
  Future _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS $tableSmoke (" +
        "$columnId INTEGER PRIMARY KEY AUTOINCREMENT," +
        "$columnDatetime INTEGER NOT NULL," +
        "$columnStress INTEGER NOT NULL" +
        ")");
    // fake datas
    // await db.execute(
    //     "INSERT INTO smoke (datetime, stress) VALUES(1600502400000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600506000000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600509600000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600513200000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600473600000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600520400000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600524000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600527600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600531200000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600534800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600538400000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600542000000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600545600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600588800000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600592400000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600596000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600599600000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600560000000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600606800000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600610400000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600614000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600617600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600621200000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600624800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600628400000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600632000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600675200000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600678800000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600682400000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600686000000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600646400000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600693200000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600696800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600700400000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600704000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600707600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600711200000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600714800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600718400000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600761600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600765200000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600768800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600772400000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600732800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600779600000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600783200000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600786800000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600790400000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600794000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600797600000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600801200000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600804800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600848000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600851600000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600855200000000,2);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600858800000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600819200000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600866000000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600869600000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600873200000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600876800000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600880400000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600884000000000,1);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600887600000000,0);" +
    //         "INSERT INTO smoke (datetime, stress) VALUES(1600891200000000,0);");
  }
}
