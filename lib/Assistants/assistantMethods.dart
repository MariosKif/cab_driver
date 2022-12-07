import 'package:cab_driver/Models/history.dart';
import 'package:cab_driver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cab_driver/Assistants/requestAssistant.dart';
import 'package:cab_driver/DataHandler/appData.dart';
import 'package:cab_driver/Models/address.dart';
import 'package:cab_driver/Models/allUsers.dart';
import 'package:cab_driver/Models/directDetails.dart';
import 'package:cab_driver/configMaps.dart';

class AssistantMethods
{
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed")
    {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(distanceText: '', durationText: '', encodedPoints: '');

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
  ///Description: This method calculate the fare price of the ride.
  ///TODO Add public Holidays
  static int calculateFares(DirectionDetails directionDetails)
  {
    //in terms of Euro
    double suitcasePrice = 1.40;
    double pricePerKm = 0;
    double basePrice = 0;
    var dt = DateTime.now();

    if(dt.hour>6 && dt.hour <20)
    {
      basePrice = 3.8;
      pricePerKm = 0.95;
    }else
    {
      basePrice = 4.8;
      pricePerKm = 1.10;
    }

    double timeTraveledFare = (directionDetails.durationValue! / 60) * 0.20;
    print(timeTraveledFare);
    double distancTraveledFare = (directionDetails.distanceValue! / 1000) * pricePerKm;
    print(distancTraveledFare);
    double totalFareAmount = basePrice + timeTraveledFare + distancTraveledFare;
    print(totalFareAmount);


    if(rideType == "Four Door")
    {

      double result = totalFareAmount * 2.0; //truncate
      return result.truncate();
    }
    else if(rideType == "Six Door")
    {
      return totalFareAmount.truncate();
    }
    else
    {
      return totalFareAmount.truncate();
    }
  }


  /// If uncomment that, uncomment also in notificationDialog.dart l:147
  static void disableHomeTabLiveLocationUpdates()
  {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentfirebaseUser.uid);
  }



  static void enableHomeTabLiveLocationUpdates()
  {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context)
  {
    //retrieve and display Earnings
    driversRef.child(currentfirebaseUser.uid).child("earnings").once().then((value) => (DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        String earnings = dataSnapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    //retrieve and display Trip History
    driversRef.child(currentfirebaseUser.uid).child("history").once().then((value) => (DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        //update total number of trip counts to provider
        Map<dynamic, dynamic>? keys = dataSnapshot.value as Map?;
        int? tripCounter = keys?.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter!);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys?.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
    {
      newRequestsRef.child(key).once().then((value) => (DataSnapshot snapshot) {
        if(snapshot.value != null)
        {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}