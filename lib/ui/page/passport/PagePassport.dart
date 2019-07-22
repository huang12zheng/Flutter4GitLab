import 'dart:convert';

import 'package:F4Lab/api.dart';
import 'package:F4Lab/const.dart';
import 'package:F4Lab/gitlab_client.dart';
import 'package:F4Lab/ui/page/passport/token.dart';
import 'package:F4Lab/ui/util/passport.dart';
import 'package:F4Lab/ui/util/size.dart';
import 'package:F4Lab/ui/page/passport/signin.dart';
import 'package:F4Lab/ui/page/passport/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PagePassport extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _PagePassportState();
}

class _PagePassportState extends State<PagePassport> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController controller;
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
              child: Container(
                width:  getWidth(context),
                height: getHeidht(context),
                child: _bodyView(),
              )
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _bodyView(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Passport'),
        bottom: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(text: "Private-Token"),
            Tab(text: "Existing"),
            Tab(text: "New"),
            // Tab(text: "Config"),
          ]
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          TokenPage(onPressed:_test),
          SigninPage(onPressed:_signin),
          SignupPage(onPressed:_signup),
          // ConfigPage()
        ],
      )
    );
  }

  _test(String _token) async{
    String _host, _version;
    // _token = tokenController.text;
    if (_token == null || _token.isEmpty) { print("Token is empty!");return ;}
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _host = sp.getString(KEY_HOST);
    _version = sp.getString(KEY_API_VERSION);
    GitlabClient.setUpTokenAndHost(privateToken:_token, host: _host,version: _version);
    final resp = await ApiService.getAuthUser();
    if (resp.success && resp.data != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Connection Success"),));
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(KEY_PRIVATE_TOKEN, _token);
      sp.setString(KEY_OAUTH_TOKEN, null);
      Future.delayed(
          Duration(milliseconds: 300), () => Navigator.pop(context, 0));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(resp.err ?? "Error"), backgroundColor: Colors.red));
    }
  }

  _signin(String access,String verify  ) async{
    try {
      // get host
      final SharedPreferences sp = await SharedPreferences.getInstance();
      String _host = sp.getString(KEY_HOST);
      String url = '$_host/oauth/token';
      // get param
      Map<String,String> param = getLoginArg(access,verify);    
      param['grant_type'] = 'password';
    
      http.Response response = await http.post(url, body: param);
      // result test
      if (response.statusCode!=200) throw Exception(response.body);
      // set token
      Map token = json.decode(response.body);
      sp.setString(KEY_OAUTH_TOKEN, token['access_token']);
      Future.delayed(
          Duration(milliseconds: 300), () => Navigator.pop(context, 0));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e?.message ?? "Error"), backgroundColor: Colors.red));
    }
  }

  _signup(Map<String,String> userInfo) async{
    
    try {
      // get host
      final SharedPreferences sp = await SharedPreferences.getInstance();
      String _host = sp.getString(KEY_HOST);
      String url = '$_host/api/v4/users?private_token=$KEY_ADMIN_TOKEN';
      // get param
      passwordCheck(userInfo);
      Map<String,String> param = getSignupArg(userInfo);
    
      http.Response response = await http.post(url, body: param);
      if (response.statusCode!=201) { print(response.body); print(response.statusCode); throw Exception(response.body);}
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Confirm In Your Email")));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e?.message ?? "Error"), backgroundColor: Colors.red));
    } 
  }
}