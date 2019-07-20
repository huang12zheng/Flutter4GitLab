import 'package:F4Lab/widget/passport/login_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TokenPage extends StatefulWidget {
  final Function onPressed;
  TokenPage({Key key,this.onPressed,}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TokenState();
}

class TokenState extends State<TokenPage> {
  final FocusNode focusNodetoken = FocusNode();
  TextEditingController tokenController=TextEditingController();
  Function onPressed;
  bool isTesting = false;
  BuildContext rootContext;
  // String _err;

   void initState() {
    onPressed = widget.onPressed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 2.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child:_token(),
        ),
        LoginButton(onPressed: ()=>onPressed(tokenController.text))
      ],
    );
  }

  _token(){
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
      child: 
      TextField(
        focusNode: focusNodetoken,
        controller: tokenController,
        autofocus: true,
        keyboardType: TextInputType.text,
        style: TextStyle(fontFamily: "WorkSansSemiBold",fontSize: 16.0,color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.userInjured,
            color: Colors.black,
            size: 22.0,
          ),
          hintText: "Token",
          hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0)),
      ),
    );
  }
}
