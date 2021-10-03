import 'package:flutter/material.dart';
import 'package:fooddelivery_app/src/Pages/sign_in_page.dart';
import 'package:fooddelivery_app/src/Scoped_model/main_model.dart';
import 'package:fooddelivery_app/src/enum/auth_mode.dart';
import 'package:fooddelivery_app/src/widgets/showLoaing_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupPage extends StatefulWidget {
  @override
  _SigupPageState createState() => _SigupPageState();
}

class _SigupPageState extends State<SignupPage> {
  bool _toogleVisibility = true;
  GlobalKey<ScaffoldState> _Scaffoldkey = GlobalKey();
  // bool _toogleConfirmVisibility = true;

  String _email;
  String _username;
  String _password;
  // String _confirmPassword;

  GlobalKey<FormState> _formkey = GlobalKey();
  Widget _buildEmailTextField() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              color: Color(0xFFBDC2CB),
              fontSize: 18.0,
            )),
        onSaved: (String email) {
          _email = email;
        },
        validator: (String email) {
          String errorMessage;
          if (!email.contains("@")) {
            errorMessage = "Your email is incorrect";
          }
          if (email.isEmpty) {
            errorMessage = "Your email is required";
          }
          return errorMessage;
        });
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
        decoration: InputDecoration(
            hintText: "Username",
            hintStyle: TextStyle(
              color: Color(0xFFBDC2CB),
              fontSize: 18.0,
            )),
        onSaved: (String username) {
          _username = username.trim();
        },
        validator: (String username) {
          String errorMessage;
          if (username.isEmpty) {
            errorMessage = "Username field is required";
          }
          if (username.length > 8) {
            errorMessage = "Please username must be less than 8";
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
        // prefixIcon: IconButton(onPressed: null, icon: Icon(Icons.password)),
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
          errorMessage = "Your Password is required";
        }
        return errorMessage;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _Scaffoldkey,
        backgroundColor: Colors.grey.shade100,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50.0),
                Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: <Widget>[
                        _buildUsernameTextField(),
                        SizedBox(height: 20.0),
                        _buildEmailTextField(),
                        SizedBox(height: 20.0),
                        _buildPasswordTextField(),
                        // SizedBox(height: 20.0),
                        // _buildConfirmPasswordTextField(),
                      ]),
                    )),
                SizedBox(height: 30.0),
                _signUpButton(),
                Divider(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account",
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
                            builder: (BuildContext context) => SignInPage()));
                      },
                      child: Text(
                        "Sign In",
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

  Widget _signUpButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return GestureDetector(
        onTap: () {
          onSubmit(model.authenticate);
          if(model.isloading){
           showLoadingIndicator(context, "Signing up......");
          }
          
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              color: Colors.blue,
               borderRadius: BorderRadius.circular(25.0)),
          child: Center(
            child: Text("Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
    });
  }

  void onSubmit(Function authenticate) {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      Map<String,dynamic> userInfo = {
      "email": _email,
      "username": _username,
      "userType": "customer",
    };
     
      authenticate(_email, _password, authmode: AuthMode.SignUp,userInfo : userInfo)
          .then((final response) {
        Navigator.of(context).pop();

        if (!response['hasError']) {
          //Navigate to the home page
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed("/main-screen");
        } else {
          //display the error in a snack bar
          Navigator.of(context).pop();
          _Scaffoldkey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
              content: Text(response['message'])));
        }
      });
    }
  }
}
