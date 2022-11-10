import 'package:firebase_database/firebase_database.dart';


class Users
{
  String? id;
  String? email;
  String? name;
  String? phone;
  bool? activated;

  Users({this.id, this.email, this.name, this.phone, this.activated});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = (dataSnapshot.child("email").value.toString());    //email = dataSnapshot.value["email"];
    name = (dataSnapshot.child("name").value.toString());     //name = dataSnapshot.value["name"];
    phone = (dataSnapshot.child("phone").value.toString());     //phone = dataSnapshot.value["phone"];
    activated = (dataSnapshot.child("false")) as bool?;   //activated = dataSnapshot.value["false"];
  }
}