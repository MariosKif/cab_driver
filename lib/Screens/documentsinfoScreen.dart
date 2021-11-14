import 'dart:io';

import 'package:cab_driver/Screens/mainscreen.dart';
import 'package:cab_driver/Screens/registrationScreen.dart';
import 'package:cab_driver/configMaps.dart';
import 'package:cab_driver/main.dart';
import 'package:file_picker/file_picker.dart';
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


  File _image;
  final _storage = FirebaseStorage.instance;
  String userId = currentfirebaseUser.uid;
  var snapshot;





  @override
  Widget build(BuildContext context)
  {
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
                    Text("Enter Car Details", style: TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),),

                    SizedBox(height: 12.0,),
                    ElevatedButton(

                      style: raisedButtonStyle,
                        child: Text('Driver License'),
                      onPressed: () { _showPicker(context);
                      driverLicenseEditingController.addListener(() { return true; });
                      var snapshot =  _storage.ref().child("$userId/Driver_License").putFile(_image).storage;



                      }),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {_showPicker(context);
                      ProfecionalDriverLicenseEditingController.addListener(() { return true; });
                      var snapshot = _storage.ref().child("$userId/Pro_Driver_License").putFile(_image).storage;
                      },
                      child: Text('Profecional Driver License'),
                    ),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {_showPicker(context);
                      vehicleRegistrationLicenseEditingController.addListener(() { return true; });
                      var snapshot = _storage.ref().child("$userId/Vehicle_Registration").putFile(_image).storage;
                      },
                      child: Text('Vehicle Registration'),
                    ),
                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {_showPicker(context);
                      UrbanClassUsePermitLicenseEditingController.addListener(() { return true; });
                      var snapshot = _storage.ref().child("$userId/Urban_Use_Permit").putFile(_image).storage;
                      },
                      child: Text('Urban class road use permit'),
                    ),

                    SizedBox(height: 26.0,),

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()
                        {
                          if(driverLicenseEditingController.hasListeners==false)   //driverLicenseEditingController.hasListeners==false
                          {
                            displayToastMessage("Please Upload your Driver License.", context);
                          }
                          else if(ProfecionalDriverLicenseEditingController.hasListeners==false)  //ProfecionalDriverLicenseEditingController.hasListeners==false
                          {
                            displayToastMessage("Please Upload your Profecional Driver License.", context);
                          }
                          else if(vehicleRegistrationLicenseEditingController.hasListeners==false)  //vehicleRegistrationLicenseEditingController.hasListeners==false
                          {
                            displayToastMessage("Please Upload your Vehicle Registration.", context);
                          }
                          else if( UrbanClassUsePermitLicenseEditingController.hasListeners==false)  //UrbanClassUsePermitLicenseEditingController.hasListeners==false
                          {
                            displayToastMessage("Please Upload your Urban Class Use Permit.", context);
                          }
                          else
                          {
                            saveDriverDocInfo(context);
                          }
                        },
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NEXT", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  void saveDriverDocInfo(context)
  {
    String userId = currentfirebaseUser.uid;


    Map docInfoMap =
    {
      "vehicle_reg": vehicleRegistrationLicenseEditingController.hasListeners == true,
      "pro_driver_license": ProfecionalDriverLicenseEditingController.hasListeners == true,
      "driver_license": driverLicenseEditingController.hasListeners == true,
      "urban_use_permit": UrbanClassUsePermitLicenseEditingController.hasListeners == true,
    };

    driversRef.child(userId).child("doc_details").set(docInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);


  }



  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }



}



