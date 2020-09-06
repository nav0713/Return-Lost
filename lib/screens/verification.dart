import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:returnlost/validators.dart';
import 'package:returnlost/widgets/header.dart';
import '../styles.dart';
import './otp_ui.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController _phoneNumberController = TextEditingController();
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              mediaQuery.padding.bottom) *
                          0.08,
                      child: Icon(
                        FontAwesomeIcons.mobileAlt,
                        size: 100.0,
                        color: redColor,
                      )),
                  SizedBox(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            mediaQuery.padding.bottom) *
                        0.05,
                  ),
                  FittedBox(
                      child: Text(
                    "Let`s start with your Mobile Number",
                    style: Theme.of(context).primaryTextTheme.subhead,
                  )),
                  SizedBox(
                    height: (mediaQuery.size.height -
                            mediaQuery.padding.top -
                            mediaQuery.padding.bottom) *
                        0.02,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Enter your mobile number we will sent",
                        style: Theme.of(context).primaryTextTheme.caption,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "you OTP to verify",
                        style: Theme.of(context).primaryTextTheme.caption,
                      ),
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
                        TextFormField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          validator: phoneNumberValidator,
                          autovalidate: true,
                          keyboardType: TextInputType.number,
                          style: otpInput(),
                          onChanged: (value) {
                            _phoneNumberController.text = value;
                          },
                          decoration: InputDecoration(
                            prefixText: "+63 ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    style: BorderStyle.none, width: 0)),
                            suffixIcon: Icon(
                              Icons.check_circle_outline,
                              color: _phoneNumberController.text.length > 10
                                  ? Colors.cyanAccent
                                  : Colors.black45,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            filled: true,
                            fillColor: Colors.black12,
                            //    prefixText: "+63 ",
                            prefixStyle: otpInput(),
                            hintText: "Ex. 9661549771",
                            hintStyle: otpInput()
                                .copyWith(letterSpacing: 2, fontSize: 18),
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
                                return OTP();
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
