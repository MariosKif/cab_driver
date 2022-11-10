import 'package:firebase_database/firebase_database.dart';

class History
{
  String? paymentMethod;
  late String createdAt;
  String? status;
  String? fares;
  late String dropOff;
  late String pickup;

  History({this.paymentMethod, required this.createdAt, this.status, this.fares, required this.dropOff, required this.pickup});

  History.fromSnapshot(DataSnapshot snapshot)
  {
    paymentMethod = (snapshot.child("payment_method").value.toString());
    createdAt = (snapshot.child("created_at").value.toString());                                      //snapshot.value["created_at"];
    status = (snapshot.child("status").value.toString());                                          //snapshot.value["status"];
    fares =(snapshot.child("fares").value.toString());                                           //snapshot.value["fares"];
    dropOff =(snapshot.child("dropoff_address").value.toString());                                     // snapshot.value["dropoff_address"];
    pickup =(snapshot.child("pickup_address").value.toString());
  }
}