import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:returnlost/screens/sign.dart';
import 'package:returnlost/styles.dart';
import 'package:returnlost/widgets/header.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            header(
              (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom) *
                  .15,
              mediaQuery.size.width,
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              alignment: Alignment.center,
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom) *
                  0.30,
              child: Column(
                children: <Widget>[
                  Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              mediaQuery.padding.bottom) *
                          0.08,
                      child: Icon(
                        FontAwesomeIcons.envelopeOpenText,
                        size: 100.0,
                        color: redColor,
                      )),
                  SizedBox(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            mediaQuery.padding.bottom) *
                        0.10,
                  ),
                  FittedBox(
                    child: Text(
                      "Verification",
                      style: Theme.of(context).primaryTextTheme.subhead,
                    ),
                  ),
                  SizedBox(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            mediaQuery.padding.bottom) *
                        0.02,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Enter OTP code sent to your number",
                        style: Theme.of(context).primaryTextTheme.caption,
                      ),
                      SizedBox(height: 10),
                      Text("+639661548775",
                          style: Theme.of(context).primaryTextTheme.caption),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      mediaQuery.padding.bottom) *
                  0.35,
              width: mediaQuery.size.width * .80,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              ),
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              ),
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              ),
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              ),
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              ),
                              Container(
                                height: (mediaQuery.size.height -
                                        mediaQuery.padding.top -
                                        mediaQuery.padding.bottom) *
                                    0.10,
                                width: mediaQuery.size.width * .10,
                                child: NumberForm(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                          width: mediaQuery.size.width * 0.45,
                          child: RaisedButton(
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return SignInScreen();
                              }));
                            },
                            child: Text(
                              "CONTINUE",
                              style: btnTextStyle(),
                            ),
                            color: redColor,
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class NumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Karla",
            fontSize: 20.0,
            color: Colors.black87),
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(style: BorderStyle.none, width: 0)),
            filled: true,
            fillColor: Colors.black12));
  }
}
