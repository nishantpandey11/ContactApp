import 'package:contactsapp/bloc/contact_event.dart';
import 'package:contactsapp/bloc/contact_state.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:contactsapp/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  Repository repository;

  ContactBloc(this.repository) : super(ContactInitialState());

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is FetchContactEvent) {
      try {
        final List<Contact> contactList = await repository.getAllContacts();
        if (contactList.isEmpty) {
          yield ContactEmptyState();
        } else {
          yield ContactLoadedState(contactList);
        }
      } catch (e) {
        print(e.toString());
        yield ContactErrorState(e.toString());
      }
    }
  }
}
