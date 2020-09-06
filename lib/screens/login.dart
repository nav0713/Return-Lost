import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:returnlost/screens/sign.dart';
import 'package:returnlost/screens/verification.dart';
import 'package:returnlost/widgets/header.dart';
import 'package:returnlost/styles.dart';
import '../validators.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../services/login_services.dart';

class LoginWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>.value(
        value: LoginState.instance, child: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = true;
  String _userName;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool insAsync = false;
  double _deviceHeight;
  double _deviceWidth;
  double _paddingTop;
  double _paddingBot;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingTop = mediaQuery.padding.bottom;
    _paddingBot = mediaQuery.padding.bottom;
    _deviceHeight = mediaQuery.size.height - (_paddingTop + _paddingBot);
    _deviceWidth = mediaQuery.size.width;
    final _auth = Provider.of<LoginState>(context);
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: redColor,
        ),
        inAsyncCall: insAsync,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header(
                mediaQuery.size.height * .13,
                _deviceWidth,
              ),
              Container(
                alignment: Alignment.topCenter,
                height: mediaQuery.size.height * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/logo_square.png"),
                )),
              ),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              Form(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState.save();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
                  //  color: Colors.green,
                  height: _deviceHeight * 0.55,
                  width: _deviceWidth * 0.85,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        validator: userNameValidator,
                        onSaved: (value) {
                          _userName = value;
                        },
                        decoration:
                            inputStyle(context, FontAwesomeIcons.userAlt)
                                .copyWith(
                          hintText: "Username",
                        ),
                      ),
                      SizedBox(
                        height: _deviceHeight * 0.03,
                      ),
                      TextFormField(
                          obscureText: _showPassword ? true : false,
                          validator: passwordValidators,
                          onSaved: (value) {
                            _password = value;
                          },
                          decoration: inputStyle(context, FontAwesomeIcons.lock)
                              .copyWith(
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
                                        ))),
                      SizedBox(
                        height: _deviceHeight * 0.08,
                      ),
                      SizedBox(
                        height: _deviceHeight * 0.06,
                        width: _deviceWidth * .7,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _auth.logIn(context, _userName.trim(), _password.trim());
                            }
                          },
                          child: Text(
                            "LOGIN",
                            style: btnTextStyle(),
                          ),
                          color: redColor,
                        ),
                      ),
                      SizedBox(
                        height: _deviceHeight * 0.02,
                      ),
                      Text(
                        "Forgot Password?",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .display1
                            .copyWith(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: _deviceHeight * 0.04,
              ),
              Container(
                height: _deviceHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don`t have an account?",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .display1
                            .copyWith(color: Colors.white, fontSize: 12)),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SignInScreen();
                        }));
                      },
                      child: Text(" Sign Up",
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
