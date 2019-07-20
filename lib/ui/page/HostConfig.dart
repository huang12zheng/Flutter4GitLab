import 'dart:convert';

import 'package:F4Lab/const.dart';
import 'package:F4Lab/gitlab_client.dart';
import 'package:F4Lab/ui/util/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class HostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfigState();
}

class ConfigState extends State<HostPage> {
  String _host, _version;
  bool isTesting = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _err;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Config"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: _host ?? "GitLab Host:",
                        helperText: "Like https://gitlab.example.com"),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    onChanged: (host) => _host = host,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: _version ?? "Your gitlab api version",
                        helperText: "Api version, default v4"),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (v) => _version = v,
                  ),
                  _err != null
                      ? Text(_err, style: TextStyle(color: Colors.red))
                      : const IgnorePointer(ignoring: true),
                  isTesting
                      ? Column(
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text("Test connectiong")
                          ],
                        )
                      : const IgnorePointer(ignoring: true),
                ],
              )
      ),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlineButton(
                        child: Text("Test & Save 👏"),
                        onPressed: () {
                          if (_host == null ||_host.isEmpty) return;
                          _testConfig();
                        },
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: OutlineButton(
                        child: Text("Reset 🙊"),
                        onPressed: () => _reset(),
                      ),
                      flex: 1,
                    ),
                  ],
                ));
          }),
    );
  }
  /// host ok, token ok success =0
  /// host ok, token cancle ok success = null(token_flag)
  /// host ok, token wrong await "token is ok"
  /// host cancle, success =0
  /// host wrong, show e.message 
  _testConfig() async {
    setState(() {
      isTesting = true;
      _err = null;
    });

    String message;
    Response resp;
    try {
        resp = await http.get('$_host/api/$_version');
        jsonDecode(utf8.decode(resp.bodyBytes));

        final SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString(KEY_HOST, _host);
        sp.setString(KEY_API_VERSION, _version ?? DEFAULT_API_VERSION);

        final result = await Navigator.pushNamed(context, '/passport');
        if (isSuccess(result)) {
          Future.delayed(
            Duration(milliseconds: 300), 
            () => Navigator.pop(context, 0)
          );
        }
        else {
          print("cancel token config");
          Future.delayed(
            Duration(milliseconds: 300), () => Navigator.pop(context, result));
        }
    } catch (e) {
      print("_testConfig: ${e.message}");
      message = e.message;
    }

    setState(() {
      isTesting = false;
      _err =  message;
    });
  }

  _loadConfig() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _host = sp.getString(KEY_HOST);
      _version = sp.getString(KEY_API_VERSION) ?? DEFAULT_API_VERSION;
    });
  }

  _reset() async {
    final sp = await SharedPreferences.getInstance();
    sp.remove(KEY_HOST);
    sp.remove(KEY_ACCESS_TOKEN);
    Navigator.pop(context, -1);
  }
}
