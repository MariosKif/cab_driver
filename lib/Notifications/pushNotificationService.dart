

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/Models/rideDetails.dart';
import 'package:cab_driver/Notifications/notificationsDialog.dart';
import 'package:cab_driver/configMaps.dart';
import 'package:cab_driver/main.dart';
import 'package:cab_driver/tabsPages/homeTabPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cab_driver/DataHandler/backgroundMessageHandler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase/firebase.dart';

import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';




class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


 // @override
  initState() {

    registerUpPushNotification();
    _listenToPushNotifications();
  }


  registerUpPushNotification() {
    //REGISTER REQUIRED FOR IOS
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission();
    }

    firebaseMessaging.getToken().then((value) {
      if (value == null) return;
      print('token $value');
    });
  }

  _listenToPushNotifications() {
  //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      print("onMessage_listenToPushNotifications ");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('onMessageOpenedApp_listenToPushNotifications');
    });
  }


  Future initialize(context) async
  {
    if (Platform.isIOS) {

      await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    print("2");
    //onMessage




   // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);

    FirebaseMessaging.onMessage.listen(( message)  {
      retrieveRideRequestInfo(getRideRequestId(message.data),context); //message.data
      print(message.data);print('OnMessage');
    });


    FirebaseMessaging.onMessageOpenedApp.listen((  message) {
      retrieveRideRequestInfo(getRideRequestId(message.data),context);
      print(message.data);
      print('onMessageOpenedApp');
    });

    FirebaseMessaging.onBackgroundMessage.call((message) async => (Map<String, dynamic> message)  =>
        retrieveRideRequestInfo(getRideRequestId(message),context));
    print('onBackgroundMessage');

  }
/*
(Map<String, dynamic> message)  =>
            retrieveRideRequestInfo(getRideRequestId(message), context);
            print("4");
(Map<String, dynamic> message) async =>
            retrieveRideRequestInfo(getRideRequestId(message), context);
            print("5");
    FirebaseMessaging.onMessage.listen((event) async =>
        (Map<String, dynamic> message) async =>
        retrieveRideRequestInfo(getRideRequestId(message), context));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
        myBackgroundMessageHandler(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
        myBackgroundMessageHandler(message);
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message), context);
        myBackgroundMessageHandler(message);
      },
    );*/






  Future<String?> getToken() async
  { print('6');
  String? token = await firebaseMessaging.getToken();
  print("This is token :: ");
  print(token);
  driversRef.child(currentfirebaseUser.uid).child("token").set(token);

  firebaseMessaging.subscribeToTopic("alldrivers");
  firebaseMessaging.subscribeToTopic("allusers");
  }


  /*
  In this faction we are taking the RideRequestID and separating for the 2 different devices
  First part is for Android and the second is for the Ios.
  We need this because they need different credentials for POST request.
  Print statements are for testing purpose.
   */
  String getRideRequestId(Map<String, dynamic> message)    //Map<String, dynamic>
  { print('7');
  String rideRequestId = "";
  if(Platform.isAndroid)
  {
    // print("This is a request ID for ANDROID::");
    rideRequestId = message['ride_request_id'];  //['data']
    //print(rideRequestId);
  }
  else
  {
    // print("This is a request ID for IOS ::");
    rideRequestId = message['ride_request_id'];
    // print(rideRequestId);
  }
  print(rideRequestId);
  return rideRequestId;
  }




  void retrieveRideRequestInfo(String rideRequestId,BuildContext context) async
  {
   // newRequestsRef.child(rideRequestId).once().then((value) => (DataSnapshot dataSnapShot)
   // async {
   // print(rideRequestId);
   // print(context);
    //newRequestsRef.child(rideRequestId).once().then((value) => (DataSnapshot dataSnapShot) {
     // print(dataSnapShot);

     // if(dataSnapShot.value != null)
    newRequestsRef.child(rideRequestId).once().then((value)
      {
        var dataSnapshot = value.snapshot;
        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();
        final map = dataSnapshot.value as Map<dynamic, dynamic>;
        //final value = dataSnapShot.value as Map<dynamic, dynamic>;

        double pickUpLocationLat = double.parse(map['pickup']['latitude'].toString());
        double pickUpLocationLng = double.parse(map['pickup']['longitude'].toString());
        String pickUpAddress = map['pickup_address'].toString();

        double dropOffLocationLat = double.parse(map['dropoff']['latitude'].toString());
        double dropOffLocationLng = double.parse(map['dropoff']['longitude'].toString());
        String dropOffAddress = map['dropoff_address'].toString();

        String paymentMethod = map['payment_method'].toString();

        String rider_name = map["rider_name"];
        String rider_phone = map["rider_phone"];

        RideDetails rideDetails = RideDetails(pickup_address: '', dropoff_address: '');
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;

        print("Information :: ");
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails,),
        );
      }
    );



  }
}
