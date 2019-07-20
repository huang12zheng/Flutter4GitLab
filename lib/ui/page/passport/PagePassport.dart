import 'package:F4Lab/api.dart';
import 'package:F4Lab/const.dart';
import 'package:F4Lab/gitlab_client.dart';
import 'package:F4Lab/ui/page/passport/token.dart';
import 'package:F4Lab/ui/util/size.dart';
import 'package:F4Lab/ui/page/passport/signin.dart';
import 'package:F4Lab/ui/page/passport/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      appBar: TabBar(
        controller: controller,
        tabs: <Tab>[
          Tab(text: "Token"),
          Tab(text: "Existing"),
          Tab(text: "New"),
          // Tab(text: "Config"),
        ]
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          TokenPage(onPressed:_test),
          SigninPage(),
          SignupPage(),
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
    GitlabClient.setUpTokenAndHost(_token, _host, _version);
    final resp = await ApiService.getAuthUser();
    if (resp.success && resp.data != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Connection Success"),));
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(KEY_ACCESS_TOKEN, _token);
      sp.setString(KEY_HOST, _host);
      sp.setString(KEY_API_VERSION, _version ?? DEFAULT_API_VERSION);
      Future.delayed(
          Duration(milliseconds: 300), () => Navigator.pop(context, 0));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(resp.err ?? "Error"), backgroundColor: Colors.red));
    }
  }
}