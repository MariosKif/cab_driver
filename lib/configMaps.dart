import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_driver/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cab_driver/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyAF487S1x35kzeaTo_lnuOXHGx_Ofr8F7w";

User firebaseUser = {} as User;

Users userCurrentInfo= {} as Users;

User currentfirebaseUser= {} as User;

StreamSubscription<Position> homeTabPageStreamSubscription= {} as StreamSubscription<Position>;

StreamSubscription<Position> rideStreamSubscription = {} as StreamSubscription<Position> ;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition = {} as Position;

Drivers driversInformation = {} as Drivers;

String title="";
double starCounter=0.0;

String rideType="";

String serverToken = "key=AAAAy0zEt4g:APA91bE_jBviKmQX9Cx-gKwuH0tcZ6RU5p46nF521CArfitmiUwZqz9kKNpiERIu2qingQ7xg-c5blsabdvNeAPVMSI4bi5pQjNYFHSFlyjMRUAPO8xW_zA3Q1FR-a9LZ9CxCz8x37_a";