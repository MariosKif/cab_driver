import 'package:firebase_database/firebase_database.dart';


class Users
{
  String id;
  String email;
  String name;
  String phone;
  bool activated;

  Users({this.id, this.email, this.name, this.phone, this.activated});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
    activated = dataSnapshot.value["false"];
  }
}