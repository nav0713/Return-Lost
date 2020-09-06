import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:returnlost/models/user.dart';
import 'package:returnlost/screens/login.dart';
import 'package:returnlost/screens/otp_ui.dart';
import 'package:returnlost/screens/verification.dart';
import 'package:returnlost/services/database_service.dart';
import 'package:returnlost/styles.dart';
import 'package:returnlost/validators.dart';
import 'package:returnlost/widgets/header.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;
  GlobalKey<FormState> _formKey;
  String _fullName;
  String _userName;
  String _password;
  bool _showPassword = true;
  bool _confirmPassword = true;
bool _loading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.top;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: SpinKitRing(
          size: 70,
          color: Colors.red,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header(
                _deviceHeight * .15,
                _deviceWidth,
              ),
              Container(
                alignment: Alignment.topCenter,
                height: _deviceHeight * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/logo_square.png"),
                )),
              ),
              SizedBox(
                height: _deviceHeight * 0.03,
              ),
Container(
  height: _deviceHeight * .63,
  child:             Form(
    key: _formKey,
    onChanged: (){
        _formKey.currentState.save();
    },
    child: Container(
        padding: EdgeInsets.only(top: 10,left: 30,right: 30),
        //  color: Colors.green,
        width: mediaQuery.size.width * 0.80,
        child: Column(
          children: <Widget>[
            ///Fullname
            TextFormField(
              validator: userNameValidator,
              onSaved: (value){
                _fullName = value.trim();
              },
              decoration:
              inputStyle(context, FontAwesomeIcons.userAlt)
                  .copyWith(
                hintText: "Full name",
              ),
            ),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            ///Username
            TextFormField(
              validator: userNameValidator,
                onSaved: (value){
                _userName = value.trim();
                },
                decoration:
                inputStyle(context, FontAwesomeIcons.userAlt)
                    .copyWith(
                  hintText: "Username",
                )),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            ///Password
            TextFormField(
              onChanged: (value){
                _password = value.trim();
              },
              obscureText: _showPassword? true:false,
              validator: passwordValidators,
              decoration: inputStyle(context, FontAwesomeIcons.lock)
                  .copyWith(
                  hintText: "Password",
                  suffixIcon: _showPassword
                      ? IconButton(
                    icon: Icon(
                      FontAwesomeIcons.eyeSlash,
                      size: 18,
                      color: redColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = false;
                      });
                    },
                  )
                      : IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = true;
                      });
                    },
                    icon: Icon(
                      FontAwesomeIcons.eye,
                      size: 18,
                      color: redColor,
                    ),
                  ))
,
            ),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            TextFormField(
              obscureText: _confirmPassword ? true : false,
              validator: (value){
                if(value.trim() != _password){
                  return "Password did not match";
                }else{
                  return null;
                }
              },
                decoration: inputStyle(context, FontAwesomeIcons.lock)
                    .copyWith(
                  hintText: "Confirm Password",
                    suffixIcon: _confirmPassword
                        ? IconButton(
                      icon: Icon(
                        FontAwesomeIcons.eyeSlash,
                        size: 18,
                        color: redColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPassword = false;
                        });
                      },
                    )
                        : IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPassword = true;
                        });
                      },
                      icon: Icon(
                        FontAwesomeIcons.eye,
                        size: 18,
                        color: redColor,
                      ),
                    ))
            ),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            SizedBox(
              height: _deviceHeight * 0.05,
              width: mediaQuery.size.width * .5,
              ///sign in button
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onPressed: () async{

                  if(_formKey.currentState.validate()){
                    setState(() {
                      _loading = true;
                    });
                    User newUser = User(
                      name: _fullName,
                      image: "https://firebasestorage.googleapis.com/v0/b/return-lost-0713.appspot.com/o/dummy-avatar-300x300.jpg?alt=media&token=33aed35f-0228-4d43-a971-80c4cc246fba",
                      username: _userName,
                    );
                    await DBService.instance.register(_userName+"@gmail.com", _password, newUser, context);
                    setState(() {
                      _loading = false;
                    });

                  }else{
                    print("un  validated");
                  }
                },
                child: Text(
                  "SIGN UP",
                  style: btnTextStyle(),
                ),
                color: redColor,
              ),
            ),
          ],
        ),
    ),
  ),
),
              SizedBox(
                height: _deviceHeight * 0.03,
              ),
              Container(
                height: _deviceHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .display1
                            .copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return LoginWithProvider();
                        }));
                      },
                      child: Text("   Login",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .display1
                              .copyWith(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                          )),
                    )
                  ],
                ),
                alignment: Alignment.center,
                color: redColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
