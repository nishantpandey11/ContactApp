import 'package:contactsapp/bloc/contact_bloc.dart';
import 'package:contactsapp/bloc/contact_event.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddContactState();
  }
}

class AddContactState extends State<AddContact> {
  String _name;
  String _phoneNumber;
  String _mobileNumber;
  bool _isFav = false;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ContactBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ContactBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _globalKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(25.0),
            children: <Widget>[
              _buildImageField(context),
              _buildNameField(),
              _buildPhoneNumberField(),
              _buildMobileNumberField(),
              _buildIsFavoriteCheckbox(),
              SizedBox(
                height: 50.0,
              ),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: () {
                  if (!_globalKey.currentState.validate()) {
                    return;
                  }
                  _globalKey.currentState.save();
                  _upsertData();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _upsertData() async {
    //todo : add contact (edit pending)
    Contact con = Contact(
        isFavorite: _isFav,
        mobileNumber: _mobileNumber,
        name: _name,
        phoneNumber: _phoneNumber,
        userImg: "");
    print(_name);
    print(_phoneNumber);
    print(_mobileNumber);
    print(_isFav);
    bloc.add(UpsertContactEvent(con));
    _resetData();
  }

  void _deleteAllContact() async {
    //todo delete data;
    bloc.add(DeleteAllContactEvent());
  }

  void _resetData() {
    _globalKey.currentState.reset();
    _isFav = false;
    _name = "";
    _phoneNumber = "";
    _mobileNumber = "";

    print("======RESET=======");
    print(_name);
    print(_phoneNumber);
    print(_mobileNumber);
    print(_isFav);
    print("======RESET DONE=======");
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is Required";
        }
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Mobile Number"),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return "Mobile number is Required";
        }
      },
      onSaved: (String value) {
        _mobileNumber = value;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Phone Number"),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return "Phone number is Required";
        }
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }

  Widget _buildImageField(BuildContext context) {
    AssetImage assetImage = AssetImage('images/pizza.png');
    Image image = Image(image: assetImage, width: 100.0, height: 100.0);
    return GestureDetector(
      child: Container(
        child: image,
      ),
      onTap: () {
        _deleteAllContact();
      },
    );
  }

  Widget _buildIsFavoriteCheckbox() {
    return CheckboxListTile(
      value: _isFav,
      onChanged: (val) {
        if (_isFav == false) {
          setState(() {
            _isFav = true;
          });
        } else if (_isFav == true) {
          setState(() {
            _isFav = false;
          });
        }
      },
      title: new Text(
        'Set Favorite',
        style: TextStyle(fontSize: 14.0),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green,
    );
  }
}
