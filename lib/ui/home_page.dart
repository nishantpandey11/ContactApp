import 'package:contactsapp/bloc/contact_bloc.dart';
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return ContactList(false);
      case 1:
         //Navigator.push(context, MaterialPageRoute(builder: (context) => AddContact()));
         return AddContact();
      case 2:
        return ContactList(true);
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
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
        centerTitle: true,
      ),
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
      body: BlocProvider(
        create: (context) => ContactBloc(Repository()),
        child: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //DbHelper helper = DbHelper();
          //helper.initializeDb();
          //insertDummyData();
          _getDrawerItemWidget(1);
        },
        tooltip: 'Add new contact',
        child: Icon(Icons.add),
      ),*/
    );
  }
}
