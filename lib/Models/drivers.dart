import 'package:firebase_database/firebase_database.dart';

class Drivers
{
  String ?name;
  String ?phone;
  String ?email;
  String ?id;
  String ?car_color;
  String ?car_model;
  String ?car_number;

  Drivers({this.name, this.phone, this.email, this.id, this.car_color, this.car_model, this.car_number,});

  Drivers.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    phone = (dataSnapshot.child("phone").value.toString());                                                            //phone = dataSnapshot.value["phone"];
    email =  (dataSnapshot.child("email").value.toString());                                                           // dataSnapshot.value["email"];
    name =  (dataSnapshot.child("name").value.toString());                                                             // dataSnapshot.value["name"];
    car_color = (dataSnapshot.child("car_color").value.toString());          //["car_details"]                         //dataSnapshot.value["car_details"]["car_color"];
    car_model = (dataSnapshot.child("car_model").value.toString());            //["car_details"]                       //dataSnapshot.value["car_details"]["car_model"];
    car_number = (dataSnapshot.child("car_number").value.toString());        //["car_details"]                          //dataSnapshot.value["car_details"]["car_number"];
  }
}