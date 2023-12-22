import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "LoanDetailsDB.db";
  static const _databaseVersion = 3;


  static const loanDetailsTable = 'LoanTable';

  static const colId = '_id';


  static const colSelectMonth = '_selectMonth';
  static const colEnterDate = '_enterDate';
  static const colEnterSource = '_enterSource';
  static const colEnterAmount = '_enterAmount';
  static const colCategory = '_category';

  late Database _db;


  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE $loanDetailsTable(
        $colId INTEGER PRIMARY KEY,
        $colSelectMonth TEXT,
        $colEnterDate TEXT,
        $colEnterSource TEXT,
        $colEnterAmount TEXT,
        $colCategory TEXT)
     ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async {
    await database.execute('drop table $loanDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertloanDetails(
      Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> updateloanDetails(
      Map<String, dynamic> row, String tableName) async {
    int id = row[colId];
    return await _db.update(
      tableName,
      row,
      where: '$colId =?',
      whereArgs: [id],
    );
  }
  Future<int>deleteloanDetails(int id,String tableName) async{
    return await _db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}