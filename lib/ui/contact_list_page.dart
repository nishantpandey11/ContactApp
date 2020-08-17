import 'dart:io';

import 'package:contactsapp/bloc/contact_bloc.dart';
import 'package:contactsapp/bloc/contact_event.dart';
import 'package:contactsapp/bloc/contact_state.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';

class ContactList extends StatefulWidget {
  final bool showFavorite;
  final HomePageState parent;

  ContactList(this.showFavorite, this.parent);

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
            if (state is ContactLoadedState) {
              List<Contact> contactList = state.contacts;
              if (widget.showFavorite) {
                contactList =
                    contactList.where((element) => element.isFavorite).toList();
              }
              if (contactList.isEmpty) {
                return _buildEmptyListUi();
              }
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
    );
  }

  Widget _buildEmptyListUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press + to add a new contact',
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
            onTap: () {
              print("contact====" + contacts[position].toString());
              widget.parent.changePage(1, contacts[position]);
            },
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: contacts[position].userImg == null ||
                      contacts[position].userImg.isEmpty
                  ? AssetImage('images/avatar.png')
                  : FileImage(File(contacts[position].userImg)),
            ),
            title: Text(contacts[position].name),
            subtitle: Text(
                "Mobile : ${contacts[position].mobileNumber}\nLandline : ${contacts[position].phoneNumber}"),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget getAvatar(String imgPath) {
    return CircleAvatar(
      //radius: 55,
      //backgroundColor: Colors.lightGreen,
      //child:CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(imgPath),
      //),
    );
  }
}
