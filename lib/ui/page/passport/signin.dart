import 'package:F4Lab/widget/passport/login_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SigninPage extends StatefulWidget {
  final Function onPressed;
  SigninPage({Key key,this.onPressed,}) : super(key: key);
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final FocusNode focusNodeAccess = FocusNode();
  final FocusNode focusNodeVerify = FocusNode();

  TextEditingController accessController=TextEditingController();
  TextEditingController verifyController=TextEditingController();

  bool obscureTextVerify=true;

  Function onPressed;

  void initState() {
    onPressed = widget.onPressed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    _access(),
                    Container(width: 250.0,height: 1.0,color: Colors.grey[400],),
                    _verify(),  
                  ],
                ),
              ),
            ],
          ),
          LoginButton(onPressed: ()=>onPressed(accessController.text,verifyController.text)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     // TODO
          //     HelpButton(name:"Forget Password",onPressed: ()=>{}),
          //     HelpButton(name:"Send SMS",onPressed: ()=>{}),
          // ]),
          // _or(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: thirdAccess(),
          // ),
        ],
      ),
      padding: EdgeInsets.only(top: 23.0),
    );
}

  List<Widget> thirdAccess() {
    return <Widget>[
            Facebook(),
            Google(),
          ];
  }

  

  _access(){
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
      child: 
      TextField(
        focusNode: focusNodeAccess,
        controller: accessController,
        autofocus: true,
        keyboardType: TextInputType.text,
        style: TextStyle(fontFamily: "WorkSansSemiBold",fontSize: 16.0,color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.userPlus,
            color: Colors.black,
            size: 22.0,
          ),
          // hintText: "Email Address",
          hintText: "Account",
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0)),
      ),
    );
  }

  _verify(){
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
      child: TextField(
        focusNode: focusNodeVerify,
        controller: verifyController,
        obscureText: obscureTextVerify,
        style: TextStyle(
            fontFamily: "WorkSansSemiBold",
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.lock,
            size: 22.0,
            color: Colors.black,
          ),
          hintText: "Password", // hintText
          hintStyle: TextStyle(
              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          suffixIcon: GestureDetector(
            onTap: ()=> _toggleLogin(),
            child: Icon(
              obscureTextVerify
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
              size: 15.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  


  void _toggleLogin() {
    setState(() {
      obscureTextVerify = !obscureTextVerify;
    });
  }
}

class Google extends StatelessWidget {
  const Google({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        // onTap: () => showInSnackBar("Google button pressed"),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.google,
            
            color: Color(0xFF0084ff),
          ),
        ),
      ),
    );
  }
}

class Facebook extends StatelessWidget {
  const Facebook({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 40.0),
      child: GestureDetector(
        // onTap: () => showInSnackBar("Facebook button pressed"),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Icon(
            FontAwesomeIcons.facebookF,
            color: Color(0xFF0084ff),
          ),
        ),
      ),
    );
  }
}

Widget _or() {
    return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.white10,
                        Colors.white,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  "Or",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white10,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
            ],
          ),
        );
  }