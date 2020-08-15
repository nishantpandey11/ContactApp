import 'package:contactsapp/bloc/contact_bloc.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:contactsapp/data/model/drawer_item.dart';
import 'package:contactsapp/data/repository.dart';
import 'package:contactsapp/ui/add_update_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_list_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  final drawerItems = [
    DrawerItem("Contact List", Icons.list),
    DrawerItem("Add New Contact", Icons.add),
    DrawerItem("Favorite Contacts", Icons.favorite)
  ];

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  Contact _currentContact;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return ContactList(false, this);
      case 1:
        return AddContact(this,_currentContact);
      case 2:
        return ContactList(true, this);
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () {
          _onSelectItem(i);
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.drawerItems[_selectedDrawerIndex].title),
          centerTitle: true,
          actions: <Widget>[
            _selectedDrawerIndex == 1
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      print("delete");
                    },
                  )
                : Text(""),
          ]),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
                child: Center(child: Text("Welcome to Contacts App")),
                decoration: BoxDecoration(color: Colors.green)),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: BlocProvider<ContactBloc>(
        create: (context) {
          return ContactBloc(Repository());
        },
        child: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
      floatingActionButton: _selectedDrawerIndex != 1
          ? FloatingActionButton(
              onPressed: () {
                //_getDrawerItemWidget(1);
                changePage(1,null);
              },
              tooltip: 'Add new contact',
              child: Icon(Icons.add),
            )
          : Text(""),
    );
  }

  changePage(int pos,Contact contact) {
    setState(() {
      _currentContact = contact;
      _selectedDrawerIndex = pos;
    });
  }
}
