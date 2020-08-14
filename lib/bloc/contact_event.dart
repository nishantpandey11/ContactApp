import 'package:contactsapp/data/model/contact.dart';
import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {}

class FetchContactEvent extends ContactEvent {
  @override
  List<Object> get props => null;
}

class UpsertContactEvent extends ContactEvent {
  final Contact contact;

  UpsertContactEvent(this.contact);

  @override
  List<Object> get props => [contact];
}

class DeleteAllContactEvent extends ContactEvent {
  @override
  List<Object> get props => null;
}
