import 'dart:io';

import 'package:chat_with_firebase/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {
  final void Function(String email, String username, String password, File file,
      bool isLogin, BuildContext context) submitForm;
  final bool isLoading;
  AuthFormWidget({this.submitForm, this.isLoading});
  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userUsername = '';
  String _userPassword = '';
  bool isLogin;
  File _userImageFile;

  void trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(_userEmail.trim(), _userPassword.trim(),
          _userUsername.trim(), _userImageFile, isLogin, context);
    }
  }

  void _pickImage(File imageFile) {
    _userImageFile = imageFile;
  }

  @override
  void initState() {
    isLogin = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    !isLogin ? UserImagePickerWidget(_pickImage) : Container(),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email Address"),
                    ),
                    isLogin
                        ? Container()
                        : TextFormField(
                            onSaved: (value) {
                              _userUsername = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: "Username"),
                          ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    widget.isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: () => trySubmit(),
                            child: Text(isLogin ? "LOGIN" : "Sign Up"),
                          ),
                    widget.isLoading
                        ? Container()
                        : FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(isLogin
                                ? "Create new account"
                                : "I already have an account"))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
