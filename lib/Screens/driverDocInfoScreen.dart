import 'dart:io';

import 'package:cab_driver/Screens/mainscreen.dart';
import 'package:cab_driver/Screens/registrationScreen.dart';
import 'package:cab_driver/configMaps.dart';
import 'package:cab_driver/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';


class DocumentsinfoScreen extends StatefulWidget
{
  static const String idScreen = "documentsinfo";

  @override
  _DocumentsinfoScreenState createState() => _DocumentsinfoScreenState();
}

class _DocumentsinfoScreenState extends State<DocumentsinfoScreen> {
  TextEditingController driverLicenseEditingController = TextEditingController();

  TextEditingController ProfecionalDriverLicenseEditingController = TextEditingController();

  TextEditingController vehicleRegistrationLicenseEditingController = TextEditingController();

  TextEditingController UrbanClassUsePermitLicenseEditingController = TextEditingController();

  final ImagePicker _picker = ImagePicker();


  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance;
  String userId = currentfirebaseUser.uid;
  var snapshot;

  late File _image;
  final picker = ImagePicker();
  late bool DriverLicense =false;
  late bool ProfectionalLicense = false;
  late bool RegistrationLicense= false;
  late bool UrbanClassPermit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/logo.png", width: 350.0, height: 200.0,),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Enter Car Details", style: TextStyle(
                        fontFamily: "Brand Bold", fontSize: 24.0),),

                    SizedBox(height: 12.0,),
                    ElevatedButton(

                        style: raisedButtonStyle,
                        child: Text('Driver License'),
                        onPressed: ()  {
                          getImage("Driver License");

                          driverLicenseEditingController.addListener(() {
                           DriverLicense = true;
                          });
                        }),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      child: Text('Profecional Driver License'),
                      onPressed: ()  {

                        getImage("Profecional Driver License");

                        ProfecionalDriverLicenseEditingController
                            .addListener(() {
                          ProfectionalLicense = true;
                        });
                      },

                    ),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: ()  {

                        getImage("Vehicle Registration");

                        vehicleRegistrationLicenseEditingController
                            .addListener(() {
                          RegistrationLicense= true;

                        });
                      },
                      child: Text('Vehicle Registration'),
                    ),
                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {

                        getImage("Urban class road use permit");

                        UrbanClassUsePermitLicenseEditingController
                            .addListener(() {
                          bool UrbanClassPermit = true;
                        });
                      },
                      child: Text('Urban class road use permit'),
                    ),

                    SizedBox(height: 26.0,),

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          //driverLicenseEditingController.hasListeners
                          if (DriverLicense == false)
                              {
                            displayToastMessage(
                                "Please Upload your Driver License.", context);
                          }
                          //ProfecionalDriverLicenseEditingController
                          //                               .hasListeners
                          else if (ProfectionalLicense == false)
                              {
                            displayToastMessage(
                                "Please Upload your Profecional Driver License.",
                                context);
                          }
                          //vehicleRegistrationLicenseEditingController
                          //                               .hasListeners
                          else if (RegistrationLicense == false)
                              {
                            displayToastMessage(
                                "Please Upload your Vehicle Registration.",
                                context);
                          }
                          // UrbanClassUsePermitLicenseEditingController
                          //                               .hasListeners
                          else if (UrbanClassPermit == false)
                              {
                            displayToastMessage(
                                "Please Upload your Urban Class Use Permit.",
                                context);
                          }
                          else {
                            saveDriverDocInfo(context);
                          }
                        },
                       // color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NEXT", style: TextStyle(fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),),
                              Icon(Icons.arrow_forward, color: Colors.white,
                                size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),

    ),
  );

  void saveDriverDocInfo(context) {
    String userId = currentfirebaseUser.uid;

    Map docInfoMap =
    {
      "vehicle_reg": vehicleRegistrationLicenseEditingController.hasListeners ==
          true,
      "pro_driver_license": ProfecionalDriverLicenseEditingController
          .hasListeners == true,
      "driver_license": driverLicenseEditingController.hasListeners == true,
      "urban_use_permit": UrbanClassUsePermitLicenseEditingController
          .hasListeners == true,
    };

    driversRef.child(userId).child("doc_details").set(docInfoMap);


    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }

  Future getImage(String type) async {
    final pickedFile =  await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        String filename = basename(_image.path);
        Reference storageReference = FirebaseStorage.instance.ref().child("$userId/$type");
        final UploadTask uploadTask = storageReference.putFile(_image);



      } else {
        print('No image selected.');
      }

    });
  }
}










