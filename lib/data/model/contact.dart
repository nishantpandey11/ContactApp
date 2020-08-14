class Contact {
  int id;
  String name;
  String mobileNumber;
  String phoneNumber;
  String userImg;
  bool isFavorite;

  Contact(
      {this.name,
      this.mobileNumber,
      this.phoneNumber,
      this.userImg,
      this.isFavorite});

  Contact.withID(
      {this.id,
      this.name,
      this.mobileNumber,
      this.phoneNumber,
      this.userImg,
      this.isFavorite});

  factory Contact.fromDatabaseJson(Map<String, dynamic> data) => Contact.withID(
        id: data['id'],
        name: data['name'],
        mobileNumber: data['mobileNumber'],
        phoneNumber: data['phoneNumber'],
        userImg: data['userImg'],
        isFavorite: data['isFavorite'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() {
    var map = Map<String, dynamic>();
    if (this.id != null) {
      map["id"] = this.id;
    }
    map["name"] = this.name;
    map["mobileNumber"] = this.mobileNumber;
    map["phoneNumber"] = this.phoneNumber;
    map["userImg"] = this.userImg;
    map["isFavorite"] = this.isFavorite == false ? 0 : 1;

    return map;
  }
}
