
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /// CLOUD FUNCTIONS DO NOT WORK
  HttpsCallable appAlive;
  HttpsCallable _getName;

  @override
  void initState() {
    _checkFunctionsWorking();
    _checkFunctionsWorkingCloud();
    _setUpCloudFunctions();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cloud functions"),
      ),
      body: ListView(children: [
        Container(
        height: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Test With http package making get requests wuth params in url", textAlign: TextAlign.center,),
            _testNameButtoon("Andrew", onPressed: (name) => _checkPersonsNameGET(name)),
            _testNameButtoon("Brett", onPressed: (name) => _checkPersonsNameGET(name)),
            _testNameButtoon("Eddie", onPressed: (name) => _checkPersonsNameGET(name)),
            _testNameButtoon("James", onPressed: (name) => _checkPersonsNameGET(name)),
            Text("Test With http package making post requests wuth params in body",textAlign: TextAlign.center),
            _testNameButtoon("Andrew", onPressed: (name) => _checkPersonsNamePOST(name),color: Colors.red),
            _testNameButtoon("Brett", onPressed: (name) => _checkPersonsNamePOST(name),color: Colors.red),
            _testNameButtoon("Eddie", onPressed: (name) => _checkPersonsNamePOST(name),color: Colors.red),
            _testNameButtoon("James", onPressed: (name) => _checkPersonsNamePOST(name),color: Colors.red),
            Text("Test With cloud package", textAlign: TextAlign.center),
            _testNameButtoon("Andrew", onPressed: (name) => _checkPersonsNameCloud(name), color: Colors.black),
            _testNameButtoon("Brett", onPressed: (name) => _checkPersonsNameCloud(name), color: Colors.black),
            _testNameButtoon("Eddie", onPressed: (name) => _checkPersonsNameCloud(name), color: Colors.black),
            _testNameButtoon("James", onPressed: (name) => _checkPersonsNameCloud(name), color: Colors.black),
          ],
        ),
      ),
      ])
		);
  }

  CupertinoButton _testNameButtoon(String name,{@required Function(String) onPressed, Color color}) {
    return CupertinoButton(
            color: color ?? Colors.blue,
            onPressed: ()=> onPressed(name),
            child: Text("Is $name a Cool?"),
          );
  }

  /// USING HTTP PACKAGE
  void _checkFunctionsWorking() async {
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      try {
        http.Response resp = await http.get("https://us-central1-cloud-functions-play-5212d.cloudfunctions.net/appAlive",  );
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${resp.body}", style: TextStyle(color: Colors.red),)));
      } catch (e) {
        showErrorMessage(context, e.toString());
      }
    });
  }

  void _checkPersonsNameGET(String name)async{
    try {
      http.Response resp = await http.get("https://us-central1-cloud-functions-play-5212d.cloudfunctions.net/isADick?name=$name",  );
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${resp.body}", style: TextStyle(color: Colors.green))));
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }

  void _checkPersonsNamePOST(String name)async{
    try {
      http.Response resp = await http.post("https://us-central1-cloud-functions-play-5212d.cloudfunctions.net/isADick", body: { "name" : name } );
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${resp.body}", style: TextStyle(color: Colors.green))));
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }

  /// USING CLOUD FUNCTIONS PACKAGE!
  void _checkFunctionsWorkingCloud() async {
    try {
      HttpsCallableResult resp = await appAlive.call();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("${resp.data} using cloud functions package", style: TextStyle(color: Colors.white),)));
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }

  void _checkPersonsNameCloud(String name)async{
    try {
      HttpsCallableResult resp = await _getName.call(<String, dynamic>{'name': name,});
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("${resp.data}")));
    } on CloudFunctionsException catch  (e) {
      showErrorMessage(context, 'Cloud functions exception with code: ${e.code}, and Details: ${e.details}, with message: ${e.message} ');
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }

  void _setUpCloudFunctions() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_)async{
        _getName = CloudFunctions.instance.getHttpsCallable(functionName: 'getName',);
        appAlive = CloudFunctions.instance.getHttpsCallable(functionName: 'appAliveCall',);
      });
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }
}

void showErrorMessage(BuildContext context, String message){
    showCupertinoDialog( 
      context: context,
      builder: (BuildContext diologContext) => new CupertinoAlertDialog(
            title: new Text("Error"),
            content: new SelectableText(message),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true, 
                  child: new Text("OK"),
                  onPressed: () => Navigator.pop(diologContext),)
            ],
          ),
    );
  }
