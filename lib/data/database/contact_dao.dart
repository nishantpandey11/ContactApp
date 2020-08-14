import 'dart:async';

import 'package:contactsapp/data/model/contact.dart';
import 'package:sqflite/sqflite.dart';

import 'contact_db_helper.dart';

class ContactDao {
  DbHelper helper = DbHelper();

  Future<List<Contact>> getAllContacts() async {
    Database db = await helper.db;
    var result = await db.rawQuery(
        "SELECT * FROM ${helper.tblContacts} order by ${helper.colName} ASC");

    /* result.then((value) {
      List<Contact> contacts = List<Contact>();
      int count = value.length;
      for (int i = 0; i < count; i++) {
        contacts.add(Contact.fromDatabaseJson(value[i]));
        debugPrint("getAllContacts--> ${contacts[i]}");
      }
      allContact = contacts;
    });*/
    List<Contact> contacts = result.isNotEmpty
        ? result.map((item) => Contact.fromDatabaseJson(item)).toList()
        : [];

    return contacts;
  }

  Future<List<Contact>> getAllFavContacts() async {
    String isFav = "1";
    Database db = await helper.db;
    var result = await db.rawQuery(
        "SELECT * FROM ${helper.tblContacts} where ${helper.colIsFavorite} = $isFav  order by ${helper.colName} ASC");

    List<Contact> contacts = result.isNotEmpty
        ? result.map((item) => Contact.fromDatabaseJson(item)).toList()
        : [];

    return contacts;
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await helper.db;
    var result = await db.insert(helper.tblContacts, contact.toDatabaseJson());
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await helper.db;
    var result = await db.update(helper.tblContacts, contact.toDatabaseJson(),
        where: "id = ?", whereArgs: [contact.id]);

    return result;
  }

  Future<int> deleteContact(int id) async {
    Database db = await helper.db;
    var result =
        await db.delete(helper.tblContacts, where: "id = ?", whereArgs: [id]);

    return result;
  }

  Future<int> deleteAllContact() async {
    Database db = await helper.db;
    var result = await db.delete(helper.tblContacts);

    return result;
  }
}
