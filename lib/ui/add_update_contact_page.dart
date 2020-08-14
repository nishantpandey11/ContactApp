import 'package:flutter/material.dart';

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
              _buildImageField(),
              _buildNameField(),
              _buildPhoneNumberField(),
              _buildMobileNumberField(),
              _buildIsFavoriteCheckbox(),
              SizedBox(
                height: 50.0,
              ),
              RaisedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
                onPressed: () {
                  if (!_globalKey.currentState.validate()) {
                    return;
                  }
                  _globalKey.currentState.save();
                  print(_name);
                  print(_phoneNumber);
                  print(_mobileNumber);
                  print(_isFav);
                },
              )
            ],
          ),
        ),
      ),
    );
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

  Widget _buildImageField() {
    AssetImage assetImage = AssetImage('images/pizza.png');
    Image image = Image(image: assetImage, width: 100.0, height: 100.0);
    return Container(
      child: image,
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
