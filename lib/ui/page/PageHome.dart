import 'package:F4Lab/const.dart';
import 'package:F4Lab/model/user.dart';
import 'package:F4Lab/ui/logic_widget/home_nav.dart';
import 'package:F4Lab/ui/util/index.dart';
import 'package:F4Lab/user_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> themeChanger;

  HomePage(this.isDark, this.themeChanger);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  User user;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    setState(() {
      isLoading = true;
    });

    String err = await UserHelper.initUser();
    setState(() {
      isLoading = false;
      this.user = UserHelper.getUser();
    });

    if (err != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err),
        duration: Duration(seconds: 5),
      ));
    }
  }

  _navigateToConfig(BuildContext c) async {
    final result = await Navigator.pushNamed(context, '/config');
    if (isSuccess(result)) _loadToken();
    else print("cancel host config");
  }

  

  _tokenChanger(bool change) {
    if (change) {
      _loadToken();
    }
  }

  _buildConfigView() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(APP_NAME),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        body: Builder(builder: (BuildContext context){
          return Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          shadows: [
                            Shadow(
                                offset: Offset(0, 5),
                                color: Theme.of(context).accentColor,
                                blurRadius: 20)
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Column(children: <Widget>[
                      Text("👇", style: TextStyle(fontSize: 50)),
                      OutlineButton(
                        onPressed: () {
                          _navigateToConfig(context);
                        },
                        child: Text("Config Host"),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          );
        })
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(key:_scaffoldKey, body: Center(child: CircularProgressIndicator()))
        : user == null
            ? _buildConfigView()
            : HomeNav(user, _tokenChanger, widget.themeChanger, widget.isDark);
  }
}
