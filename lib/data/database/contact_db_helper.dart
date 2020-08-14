import 'dart:io';

import 'package:contactsapp/data/database/contact_dao.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  final String dbName = "contacts.db";
  final String tblContacts = "contacts";
  final String colId = "id";
  final String colName = "name";
  final String colMobileNumber = "mobileNumber";
  final String colPhoneNumber = "phoneNumber";
  final String colUserName = "userImg";
  final String colIsFavorite = "isFavorite";

  DbHelper._internal();

  factory DbHelper() => _dbHelper;

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path + dbName);
    var dbContacts = await openDatabase(path, version: 1, onCreate: _createDb,);
    return dbContacts;
  }

  void _createDb(Database db, int version) async {
    await db.execute("CREATE TABLE $tblContacts ("
        "$colId INTEGER PRIMARY KEY, "
        "$colName TEXT, "
        "$colMobileNumber TEXT, "
        "$colPhoneNumber TEXT, "
        "$colUserName TEXT, "
        "$colIsFavorite INTEGER "
        ")");
  }

  void insertDummyData() async {
    ContactDao dao = ContactDao();
    for (int i = 1; i < 6; i++) {
      print("insertDummyData $i");
      Contact con = Contact.withID(
          id: i,
          isFavorite: i % 2 == 0 ? true : false,
          mobileNumber: "1234567890 - $i",
          name: "Nishant $i",
          phoneNumber: "011 12345678 +$i",
          userImg: "");
      dao.insertContact(con);
    }
  }
}
