import 'package:contactsapp/data/model/contact.dart';
import 'package:equatable/equatable.dart';

abstract class ContactState extends Equatable {}

class ContactInitialState extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoadedState extends ContactState {
  final List<Contact> contacts;

  ContactLoadedState(this.contacts);

  @override
  List<Object> get props => null;
}

class ContactEmptyState extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactErrorState extends ContactState {
  final String msg;

  ContactErrorState(this.msg);

  @override
  List<Object> get props => null;
}

class ContactUpsertedState extends ContactState {
  @override
  List<Object> get props => null;
}

class AllContactDeletedState extends ContactState {
  @override
  List<Object> get props => null;
}

class ContactDeletedState extends ContactState {
  @override
  List<Object> get props => null;
}
