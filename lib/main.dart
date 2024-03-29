import 'package:cab_driver/Screens/carInfoScreen.dart';
import 'package:cab_driver/Screens/driverDocInfoScreen.dart';
import 'package:cab_driver/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cab_driver/Screens/loginScreen.dart';
import 'package:cab_driver/Screens/mainScreen.dart';
import 'package:cab_driver/Screens/registrationScreen.dart';
import 'package:cab_driver/DataHandler/appData.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'Models/allUsers.dart';


/// FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); on the main
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
/*
Future<void> backgroundHandler(RemoteMessage message) async
{
  print(message.data.toString());
  print(message.notification?.title);
}
*/
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
 // FirebaseMessaging.onBackgroundMessage(backgroundHandler);   //backgroundHandler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


 User? currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.ref().child("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.ref().child("drivers").child(currentfirebaseUser.uid).child("newRide");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Taxi Driver App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
        //initialRoute:  MainScreen.idScreen,
        routes:
        {
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
          DocumentsinfoScreen.idScreen: (context) => DocumentsinfoScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

