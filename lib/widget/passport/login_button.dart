
import 'package:F4Lab/util/theme.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      splashColor: AppColors.loginGradientEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 42.0),
        child: Text(
          "LOGIN",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontFamily: "WorkSansBold"),
        ),
      ),
      onPressed: () => onPressed()
    );
  }
}

class HelpButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  HelpButton({
    Key key,
    this.name,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: FlatButton(
          onPressed: ()=>onPressed(),
          child: Text(
            name,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "WorkSansMedium"),
          )),
    );
  }
}
