import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cab_driver/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title="";
double starCounter=0.0;

String rideType="";

String serverToken = "key=AAAAgyudES0:APA91bGZjOc3Dje2kxGTfvUicXFA8XaeOGB3WTpcp0DxBEOwondnXAVt-_koh_l_iJGeO6Czt2mEq8x65EvDuJIZ_LCqgY0hkWQ3bqU5mBjspjCMAdz_pQ8QBNyru3AFLuWIgq9op3cs";