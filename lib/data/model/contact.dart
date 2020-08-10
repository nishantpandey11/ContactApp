class Contact {
  int id;
  String name;
  String mobileNumber;
  String phoneNumber;
  String userImg;
  bool isFavorite;

  Contact(
      {this.id,
      this.name,
      this.mobileNumber,
      this.phoneNumber,
      this.userImg,
      this.isFavorite});

  factory Contact.fromDatabaseJson(Map<String, dynamic> data) => Contact(
        id: data['id'],
        name: data['name'],
        mobileNumber: data['mobileNumber'],
        phoneNumber: data['phoneNumber'],
        userImg: data['userImg'],
        isFavorite: data['isFavorite'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "name": this.name,
        "mobileNumber": this.mobileNumber,
        "phoneNumber": this.phoneNumber,
        "userImg": this.userImg,
        "isFavorite": this.isFavorite == false ? 0 : 1,
      };
}
