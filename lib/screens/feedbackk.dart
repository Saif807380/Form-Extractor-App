import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../widgets/app_drawer.dart';

class Feedbackk extends StatefulWidget {
  static const routeName = '/Feedbackk';

  @override
  __FeedbackkState createState() => __FeedbackkState();
}

class __FeedbackkState extends State<Feedbackk> {
  File _storedImage;
  Future<void> _takePicture() async {

    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _storedImage = imageFile;
    });
  }
   final appBar = AppBar(
    title: Text(
  "Terna_App",
          style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(143, 148, 251, 1),
  );

  

  Future<void> _selectPicture() async {

    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _storedImage = imageFile;
    });
  }

  Widget doneButton() {
    return _storedImage != null? Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 45.0),
      child: MaterialButton(
        textColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Text("Done"),
        color: Theme.of(context).accentColor,
        splashColor: Colors.white,
        elevation: 5,
        shape: StadiumBorder(),
      ),
    ): SizedBox();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(appBar),
        appBar: appBar,
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.grey,
                ),
              ),
              child: _storedImage != null
                  ? Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      'Upload your feedback iamge',
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
              Container(
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                color: Color.fromRGBO(143, 148, 251, 1),
                 onPressed: _takePicture,
                 child: Text("Take from Camera"),
                ),
              )
            , Container(
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                color: Color.fromRGBO(143, 148, 251, 1),
                onPressed: _selectPicture,
                child: Text("Pick from Gallery"),
              ),
              ),
            doneButton(),
          ],
        ),
      );
  }
 }
