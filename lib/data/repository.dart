import 'database/contact_dao.dart';
import 'model/contact.dart';

class Repository {
  final contactDao = ContactDao();

  Future<List<Contact>> getAllContacts() => contactDao.getAllContacts();

  Future<List<Contact>> getAllFavoriteContacts() => contactDao.getAllFavContacts();

  Future insertContact(Contact contact) => contactDao.insertContact(contact);

  Future updateContact(Contact contact) => contactDao.updateContact(contact);

  Future deleteContact(int id) => contactDao.deleteContact(id);
}
