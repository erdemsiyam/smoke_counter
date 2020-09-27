import 'package:smoke_counter/model/smoke_model.dart';
import 'package:smoke_counter/repository/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../locator.dart';

class SmokeRepository {
  /* Static Properties */
  static List<SmokeModel> smokes = new List<SmokeModel>();
  /* Static Methods */
  static Future<void> getInitialDatas() async {
    await locator<SmokeRepository>()
        .getAllSmoke(); // içilen sigaralar dbden alınır
  }

  /* Class Methods */
  Future<List<SmokeModel>> getAllSmoke() async {
    // smoke liste boş ise sql den çek
    if (smokes.isEmpty) {
      smokes = await locator<SmokeRepository>()._getAllSmokeFromDB();
    }
    return smokes;
  }

  Future<bool> addSmoke(SmokeModel smokeModel) async {
    Database db = await DatabaseHelper.getDatabase();
    if (await db.insert(DatabaseHelper.tableSmoke, smokeModel.toMap()) > -1) {
      smokes.add(smokeModel); // db kayıt olursa static listeye de kayıt edilir
      return true;
    }
    return false;
  }

  /* Private Methods */
  Future<List<SmokeModel>> _getAllSmokeFromDB() async {
    Database db = await DatabaseHelper.getDatabase();

    // verileri çek
    List<Map<String, dynamic>> results =
        await db.query(DatabaseHelper.tableSmoke);
    List<SmokeModel> smokes = new List<SmokeModel>();
    for (Map<String, dynamic> i in results) {
      smokes.add(SmokeModel.fromMap(i));
    }

    return smokes;
  }
}
