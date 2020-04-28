import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../screens/companyv.dart';

class VoiceHome extends StatefulWidget {
  static List<LocaleName> localeNames = [];
  static const String routeName = '/voice-home';
  final List properties;

  const VoiceHome({Key key, @required this.properties}) : super(key: key);
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  final SpeechToText speech = SpeechToText();
  // print(properties[0]);
  List<String> prescription = new List();

  List<TextEditingController> controllers = new List(5);

  List<String> result = new List(5);

  List<String> temp = new List(5);

  List<double> level = new List(5);

  List<String> lastError = new List(5);

  List<String> lastStatus = new List(5);

  String currentLocaleId = "";

  List<bool> hasSpeech = new List(5);
  var res, pres;
  // var properties = ['palaka', 'hello', 'f', 'sdfdgn', 'vsfbnhm'];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      hasSpeech[i] = true;
      controllers[i] = new TextEditingController();
      result[i] = "";
      temp[i] = "";
      level[i] = 0.0;
      lastStatus[i] = "";
      lastError[i] = "";
      initSpeechState(i);
    }
    print("======================");
    // print(properties[0]);
  }

  Future<void> initSpeechState(int i) async {
    bool _hasSpeech = await speech.initialize(
        onError: (error) => errorListener(error, i),
        onStatus: (status) => statusListener(status, i));
    if (_hasSpeech) {
      VoiceHome.localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      hasSpeech[i] = _hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              for (int i = 0; i < 5; i++) {
                prescription.add(controllers[i].text);
              }
            },
            label: Text(
              "Save",
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Aleo',
                  fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(15),
                elevation: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.properties[0],
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Aleo',
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Name, age and gender...",
                            hintStyle: TextStyle(
                                fontFamily: 'Aleo',
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controllers[0],
                        onChanged: (result) {
                          temp[0] = result;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.mic),
                            color: Theme.of(context).accentColor,
                            onPressed: !hasSpeech[0] || speech.isListening
                                ? null
                                : () => startListening(0),
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: speech.isListening
                                ? () => stopListening(0)
                                : null,
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.cancel),
                            onPressed: (speech.isListening ||
                                    (!speech.isListening && temp[0] != ""))
                                ? () => cancelListening(0)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(15),
                elevation: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        widget.properties[1],
                        style: TextStyle(
                            fontFamily: 'Aleo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Fever...",
                            hintStyle: TextStyle(
                                fontFamily: 'Aleo',
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controllers[1],
                        onChanged: (result) {
                          temp[1] = result;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.mic),
                            onPressed: !hasSpeech[1] || speech.isListening
                                ? null
                                : () => startListening(1),
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: speech.isListening
                                ? () => stopListening(1)
                                : null,
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.cancel),
                            onPressed: (speech.isListening ||
                                    (!speech.isListening && temp[1] != ""))
                                ? () => cancelListening(1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          widget.properties[2],
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Aleo',
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: "Initial Diagnosis",
                              hintStyle: TextStyle(
                                  fontFamily: 'Aleo',
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic)),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controllers[2],
                          onChanged: (result) {
                            temp[2] = result;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              color: Theme.of(context).accentColor,
                              icon: Icon(Icons.mic),
                              onPressed: !hasSpeech[2] || speech.isListening
                                  ? null
                                  : () => startListening(2),
                            ),
                            IconButton(
                              icon: Icon(Icons.stop),
                              onPressed: speech.isListening
                                  ? () => stopListening(2)
                                  : null,
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.cancel),
                              onPressed: (speech.isListening ||
                                      (!speech.isListening && temp[2] != ""))
                                  ? () => cancelListening(2)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(15),
                elevation: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        widget.properties[3],
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Aleo',
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Tablets, syrups or creams...",
                            hintStyle: TextStyle(
                                fontFamily: 'Aleo',
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controllers[3],
                        onChanged: (result) {
                          temp[3] = result;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            color: Theme.of(context).accentColor,
                            icon: Icon(Icons.mic),
                            onPressed: !hasSpeech[3] || speech.isListening
                                ? null
                                : () => startListening(3),
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: speech.isListening
                                ? () => stopListening(3)
                                : null,
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.cancel),
                            onPressed: (speech.isListening ||
                                    (!speech.isListening && temp[3] != ""))
                                ? () => cancelListening(3)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          widget.properties[4],
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Aleo',
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: "Healthy Diet...",
                              hintStyle: TextStyle(
                                  fontFamily: 'Aleo',
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic)),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controllers[4],
                          onChanged: (result) {
                            temp[4] = result;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              color: Theme.of(context).accentColor,
                              icon: Icon(Icons.mic),
                              onPressed: !hasSpeech[4] || speech.isListening
                                  ? null
                                  : () => startListening(4),
                            ),
                            IconButton(
                              icon: Icon(Icons.stop),
                              onPressed: speech.isListening
                                  ? () => stopListening(0)
                                  : null,
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.cancel),
                              onPressed: (speech.isListening ||
                                      (!speech.isListening && temp[4] != ""))
                                  ? () => cancelListening(4)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

//========================================================================================================
  void startListening(int i) {
    result[i] += temp[i];
    print(result[i]);
    result[i] += " ";
    lastError[i] = "";
    speech.listen(
        onResult: (result) => resultListener(result, i),
        listenFor: Duration(seconds: 300),
        localeId: currentLocaleId,
        onSoundLevelChange: (level) => soundLevelListener(level, i));
    setState(() {});
  }

  void stopListening(int i) {
    speech.stop();
    setState(() {
      level[i] = 0.0;
    });
  }

  void cancelListening(int i) {
    speech.cancel();
    setState(() {
      print("Cancel is called");
      temp[i] = "";
      controllers[i].clear();
      result[i] = "";
      level[i] = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result1, int i) {
    setState(() {
      temp[i] = "${result1.recognizedWords}";
      controllers[i].text = result[i] + temp[i];
    });
  }

  void soundLevelListener(double level1, int i) {
    setState(() {
      level[i] = level1;
    });
  }

  void errorListener(SpeechRecognitionError error, int i) {
    setState(() {
      lastError[i] = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status, int i) {
    setState(() {
      lastStatus[i] = "$status";
    });
  }
}
