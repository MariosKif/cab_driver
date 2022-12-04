import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';


//@JsonSerializable()
class Drivers
{
  String? name;
  String? phone;
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
    car_number = (dataSnapshot.child("car_number").value.toString());
    //final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(Drivers.fromSnapshot(dataSnapshot)));//["car_details"]                          //dataSnapshot.value["car_details"]["car_number"];

  }

  Drivers DriversFromJson(Map<String, dynamic> json) => Drivers(
    name: json['name'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    id: json['id'] as String,
    car_color: json['car_color'] as String,
    car_model: json['car_model'] as String,
    car_number: json['car_number'] as String,
    //dateOfBirth: json['dateOfBirth'] == null
      //  ? null
       // : DateTime.parse(json['dateOfBirth'] as String),
  );



  //factory Drivers.fromJson(Map<String, dynamic> driversjson) => _$DriversFromJson(driversjson);
  //Map<String, dynamic> toJson() => _$DriversToJson(this);



 // Map get value {
  // return {};
 //}
/*
  DataSnapshot<String, dynamic> invalidMap;

  final validMap =
  json.decode(json.encode(invalidMap)) as Map<String, dynamic>;

*/
/*
  final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(Drivers.fromSnapshot(dataSnapshot)
      {
      id = dataSnapshot.key;
      phone = (dataSnapshot.child("phone").value.toString());                                                            //phone = dataSnapshot.value["phone"];
      email =  (dataSnapshot.child("email").value.toString());                                                           // dataSnapshot.value["email"];
      name =  (dataSnapshot.child("name").value.toString());                                                             // dataSnapshot.value["name"];
      car_color = (dataSnapshot.child("car_color").value.toString());          //["car_details"]                         //dataSnapshot.value["car_details"]["car_color"];
      car_model = (dataSnapshot.child("car_model").value.toString());            //["car_details"]                       //dataSnapshot.value["car_details"]["car_model"];
      car_number = (dataSnapshot.child("car_number").value.toString());        //["car_details"]                          //dataSnapshot.value["car_details"]["car_number"];
      }));


 */
}

