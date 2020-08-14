import 'package:contactsapp/bloc/contact_bloc.dart';
import 'package:contactsapp/bloc/contact_event.dart';
import 'package:contactsapp/bloc/contact_state.dart';
import 'package:contactsapp/data/database/contact_dao.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_update_contact_page.dart';

class ContactList extends StatefulWidget {
  final bool showFavorite;

  ContactList(this.showFavorite);

  @override
  State<StatefulWidget> createState() {
    return ContactListState();
  }
}

class ContactListState extends State<ContactList> {
  ContactBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ContactBloc>(context);
    bloc.add(FetchContactEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            print("state----> $state");
            if (state is ContactLoadedState) {
              List<Contact> contactList = state.contacts;
              if (widget.showFavorite) {
                contactList =
                    contactList.where((element) => element.isFavorite).toList();
              }

              /* contactList.forEach((element) {
                print("element-->${element.name} -  ${element.isFavorite}");
              });*/
              return _buildContactList(contactList);
            } else if (state is ContactEmptyState) {
              return _buildEmptyListUi();
            } else if (state is ContactErrorState) {
              return _buildLoadingUi();
            } else {
              return _buildLoadingUi();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //DbHelper helper = DbHelper();
          //helper.initializeDb();
          //insertDummyData();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddContact()));
        },
        tooltip: 'Add new contact',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyListUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press + to add a contact',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Loading...',
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(List<Contact> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(contacts[position].id.toString()),
            ),
            title: Text(contacts[position].name),
            subtitle: Text(contacts[position].mobileNumber),
          ),
        );
      },
    );
  }

  void insertDummyData() {
    ContactDao dao = ContactDao();
    for (int i = 1; i < 6; i++) {
      print("insertDummyData $i");
      Contact con = Contact(
          isFavorite: i % 2 == 0 ? true : false,
          mobileNumber: "1234567890 - $i",
          name: "Nishant $i",
          phoneNumber: "011 12345678 +$i",
          userImg: "");
      dao.insertContact(con);
    }
  }
}
