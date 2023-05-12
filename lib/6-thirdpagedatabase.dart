import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class thirdpagedatabase {
  Future<Database> getDatabase1() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE createcontact (ID integer primary key Autoincrement, NAME text, PHONE text,USERID text)');
    });
    return database;
  }

  Future<void> insertData(String name, String number, String s, Database dbb) async {
      String insert =
          "insert into createcontact (NAME,PHONE,USERID)  values('$name','$number','$s')";

      int aa = await dbb.rawInsert(insert);

      print("===========$aa");

  }

  Future<List<Map>> viewData(int userid , Database dbb) async {
    String viewdata = "select * From createcontact where USERID = '$userid' ";

    List<Map> list = await dbb.rawQuery(viewdata);

    return list;
  }

  Future<void> deleteData(int id, Database database) async {

    String datadelete = "delete from createcontact where ID = '$id'";

    int delete = await database.rawDelete(datadelete);

    print("===$delete");
  }

  Future<void> updateData(String name, String phnum, hh, Database database1) async {

    String update = "update createcontact set NAME = '$name' , PHONE = '$phnum' where ID = '$hh'";

    int updatee = await database1.rawUpdate(update);

  }


}
