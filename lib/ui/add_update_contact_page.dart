import 'dart:io';

import 'package:contactsapp/bloc/contact_bloc.dart';
import 'package:contactsapp/bloc/contact_event.dart';
import 'package:contactsapp/data/model/contact.dart';
import 'package:contactsapp/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  final HomePageState parent;
  final Contact currentContact;

  AddContact(this.parent, this.currentContact);

  @override
  State<StatefulWidget> createState() {
    return AddContactState();
  }
}

class AddContactState extends State<AddContact> {
  File _image;
  final picker = ImagePicker();

  bool _isFav = false;
  int _id;
  String _imgPath = "";

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ContactBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ContactBloc>(context);
    Contact contact = widget.currentContact;
    if (contact != null) {
      _nameController.text = contact.name;
      _phoneController.text = contact.phoneNumber;
      _mobileController.text = contact.mobileNumber;

      _isFav = contact.isFavorite;
      _id = contact.id;
      _imgPath = contact.userImg;
    }
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
                height: 30.0,
              ),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  _id == null ? "Save" : "Update",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onPressed: () {
                  if (!_globalKey.currentState.validate()) {
                    return;
                  }
                  _globalKey.currentState.save();
                  _upsertData();
                },
              ),
              _id != null
                  ? RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      onPressed: () {
                        deleteContact(_id);
                      },
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      _imgPath = pickedFile.path;
    });
  }

  void _upsertData() async {
    Contact con = Contact.withID(
        mobileNumber: _mobileController.text.trim(),
        name: (_nameController.text[0].toUpperCase() +
                _nameController.text.substring(1))
            .trim(),
        phoneNumber: _phoneController.text.trim(),
        id: _id,
        isFavorite: _isFav,
        userImg: _imgPath == null ? "" : _imgPath);
    bloc.add(UpsertContactEvent(con));
    _resetData();
  }

  void _deleteAllContact() async {
    bloc.add(DeleteAllContactEvent());
  }

  void deleteContact(int id) {
    bloc.add(DeleteContactEvent(id));
    _resetData();
  }

  void _resetData() {
    _globalKey.currentState.reset();

    _isFav = false;
    _id = null;
    _imgPath = "";
    _image = null;
    _nameController.clear();
    _mobileController.clear();
    _phoneController.clear();
    widget.parent.changePage(0, null);
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: "Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is Required";
        }
      },
      onSaved: (String value) {
        _nameController.text = value;
      },
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: _mobileController,
      decoration: InputDecoration(labelText: "Mobile Number"),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return "Mobile number is Required";
        } else if (value.length < 10) {
          return "Mobile number must be of 10 Digit";
        }
      },
      onSaved: (String value) {
        _mobileController.text = value;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(labelText: "Phone Number"),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return "Phone number is Required";
        }
      },
      onSaved: (String value) {
        _phoneController.text = value;
      },
    );
  }

  Widget _buildImageField(BuildContext context) {
    AssetImage assetImage = AssetImage('images/avatar.png');
    Image image = Image(image: assetImage, width: 100.0, height: 100.0);

    return GestureDetector(
      child: Container(
        child:
            _imgPath == null || _imgPath.isEmpty ? image : getAvatar(_imgPath),
      ),
      onTap: () {
        getImage();
      },
      onLongPress: () {
        _deleteAllContact();
      },
    );
  }

  Widget getAvatar(String imgPath) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(File(imgPath)),
      ),
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

  @override
  void dispose() {
    super.dispose();
    _mobileController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }
}
