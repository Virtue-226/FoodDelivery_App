import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/screens/Forget_password_screen.dart';
import 'package:fooddelivery_app/src/widgets/button.dart';
import 'package:fooddelivery_app/src/widgets/showLoaing_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  
  bool _toogleVisibility = true;
  String _password;
  String _email;
  GlobalKey<FormState> _formkey = GlobalKey();
  GlobalKey<ScaffoldState> _Scaffoldkey = GlobalKey();

  Widget _buildEmailTextField() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              color: Color(0xFFBDC2CB),
              fontSize: 18.0,
            )),
        onSaved: (String email) {
          _email = email.trim();
        },
        validator: (String email) {
          String errorMessage;
          if (!email.contains("@")) {
            errorMessage = "Invalid email";
          }
          return errorMessage;
        });
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(
            color: Color(0xFFBDC2CB),
            fontSize: 18.0,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _toogleVisibility = !_toogleVisibility;
              });
            },
            icon: _toogleVisibility
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          ),
        ),
        obscureText: _toogleVisibility,
        onSaved: (String password) {
          _password = password;
        },
        validator: (String password) {
          String errorMessage;
          if (password.isEmpty) {
            errorMessage = "Password is required";
          }

          return errorMessage;
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _Scaffoldkey,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 100.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (BuildContext context) =>
                    //               ForgetPwScreen()));
                    //     },
                    //     child: Text(
                    //       "Forgotten Password?",
                    //       style: TextStyle(
                    //           fontSize: 18.0, color: Colors.blueAccent),
                    //     ))
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgetPwScreen()));
                      },
                      child: Text(
                        "Forgotten Password?",
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: <Widget>[
                        _buildEmailTextField(),
                        SizedBox(height: 20.0),
                        _buildPasswordTextField()
                      ]),
                    )),
                SizedBox(height: 30.0),
                _buildSignInButton(),
                Divider(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account",
                      style: TextStyle(
                          color: Color(0xFFBDC2CB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignupPage()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return GestureDetector(
        onTap: () {
          onSubmit(model.authenticate);
          if (model.isloading) {
            showLoadingIndicator(context, "Signing In....");  
          }
          
        },
        child: Button(
          btnText: "Sign In",
        ),
      );
    });
  }

  void onSubmit(Function authenticate) {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      authenticate(_email, _password).then((final response) {
        // print("$response");
        if (!response['hasError']) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed("/main-screen");
        } else {
          Navigator.of(context).pop();
          _Scaffoldkey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
              content: Text(response['message'])));
        }
      });
    }
  }
}
