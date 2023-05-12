import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseClass {
  Future<Database> GetDatabase() async {                            //CREATE TABLE
    // Get a location using getDatabasesPat
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo1.dbb');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database dbb, int version) async {
      // When creating the db, create the table
      await dbb.execute(
          'create table Usersignupdata (ID integer primary key Autoincrement , NAME text,NUMBER text , EMAIL TEXT,PASSWORD text, CONPASSWORD text)');
    });
    return database;

  }

  Insertuserdata(String fullname, String phonenum, String email, String password, String conpass, Database db) async {
    String checksql = "select * from Usersignupdata where EMAIL ='$email'  or  NUMBER  = '$phonenum'";
      List<Map> list = await db.rawQuery(checksql);
      return list;
  }


  Future<List<Map>> Loginuser(
      String email, String password, Database databasee) async {
    String loginuser =
        "select * From Usersignupdata where EMAIL = '$email' and  PASSWORD = '$password' ";
    List<Map> list = await databasee.rawQuery(loginuser);
    print("======$list");
    return list;
  }

  Insertvaliduser(String fullname, String phonenum, String email, String password, String conpass, Database dbb) async {
      String insert =
          "insert into Usersignupdata (NAME,NUMBER,EMAIL,PASSWORD,CONPASSWORD)  values('$fullname','$phonenum','$email','$password','$conpass')";

      int aa = await dbb.rawInsert(insert);

      print("====$aa");
  }



}
