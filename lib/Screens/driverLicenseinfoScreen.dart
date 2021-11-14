import 'dart:io';
import 'dart:typed_data';

import 'package:cab_driver/Screens/mainscreen.dart';
import 'package:cab_driver/Screens/registrationScreen.dart';
import 'package:cab_driver/configMaps.dart';
import 'package:cab_driver/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cab_driver/Assistants/firebaseApi.dart';



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



  File _image;
  final picker = ImagePicker();



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
                        onPressed: () async {
                          getImage();

                          String filename = basename(_image.path);
                          Reference storageReference = FirebaseStorage.instance.ref().child("<Bucket Name>/$filename");
                          final UploadTask uploadTask = storageReference.putFile(_image);





                          driverLicenseEditingController.addListener(() {
                            return true;
                          });
                        }),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {
                        //selectFile();

                        ProfecionalDriverLicenseEditingController
                            .addListener(() {
                          return true;
                        });
                      },
                      child: Text('Profecional Driver License'),
                    ),

                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {



                        vehicleRegistrationLicenseEditingController
                            .addListener(() {
                          return true;
                        });
                      },
                      child: Text('Vehicle Registration'),
                    ),
                    SizedBox(height: 15.0,),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {
                        // selectFile();


                        UrbanClassUsePermitLicenseEditingController
                            .addListener(() {
                          return true;
                        });
                      },
                      child: Text('Urban class road use permit'),
                    ),

                    SizedBox(height: 26.0,),

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (driverLicenseEditingController.hasListeners ==
                              false) //driverLicenseEditingController.hasListeners==false
                              {
                            displayToastMessage(
                                "Please Upload your Driver License.", context);
                          }
                          else if (ProfecionalDriverLicenseEditingController
                              .hasListeners ==
                              false) //ProfecionalDriverLicenseEditingController.hasListeners==false
                              {
                            displayToastMessage(
                                "Please Upload your Profecional Driver License.",
                                context);
                          }
                          else if (vehicleRegistrationLicenseEditingController
                              .hasListeners ==
                              false) //vehicleRegistrationLicenseEditingController.hasListeners==false
                              {
                            displayToastMessage(
                                "Please Upload your Vehicle Registration.",
                                context);
                          }
                          else if (UrbanClassUsePermitLicenseEditingController
                              .hasListeners ==
                              false) //UrbanClassUsePermitLicenseEditingController.hasListeners==false
                              {
                            displayToastMessage(
                                "Please Upload your Urban Class Use Permit.",
                                context);
                          }
                          else {
                            saveDriverDocInfo(context);
                          }
                        },
                        color: Colors.black54,
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

  /*_imgFromCamera() async {

    XFile image = await _picker.pickImage(source: ImageSource.camera);


    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {

    XFile image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }
*/
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


  /* void _showPicker(context) {
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

  */
/*
  Future selectFile() async {
    final result =
    await FilePicker.platform..pickFiles();

    if (result == null) return;
     Uint8List file = result.files.single.bytes;





    setState(() => file = File(path));

  }

 */

  //Future uploadFile() async {
    /*  if (file == null) return;

    final fileName = basename(file.path);
    final destination = '$userId/name';

    firebaseApi.uploadFile(destination, file);

   */
/*
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path);
    }

      // Upload file
       FirebaseStorage.instance.ref('$userId/name').putData;
    }

 */

  Future getImage() async {
    final pickedFile =  await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);


      } else {
        print('No image selected.');
      }

    });
  }





  }










