import 'package:flutter/material.dart';
import 'package:fluttertodoapp/authen/widget.dart';
import 'package:fluttertodoapp/widgets_methods/methods.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignupLogin extends StatelessWidget {
  const SignupLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupLoginStateful(),
    );
  }
}

class SignupLoginStateful extends StatefulWidget {
  const SignupLoginStateful({Key? key}) : super(key: key);

  @override
  State<SignupLoginStateful> createState() => _SignupLoginStatefulState();
}

class _SignupLoginStatefulState extends State<SignupLoginStateful> {
  String email = "";
  String name = "";
  String pass = "";
  bool isSignup = true;
  final _formKey = GlobalKey<FormState>();
  bool _toggleVisiblity = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 80, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(title: isSignup ? "Sign Up" : "Login"),
              const SizedBox(
                height: 60,
              ),
              Text(
                isSignup
                    ? "Sign up with one of the following options"
                    : "Login with one of the following options",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _container(context, MdiIcons.google),
                  _container(context, MdiIcons.apple),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSignup
                            ? _text(
                                "Name", const EdgeInsets.fromLTRB(0, 40, 0, 10))
                            : const SizedBox.shrink(),
                        isSignup
                            ? _textFieldName("Enter your name", false)
                            : const SizedBox.shrink(),
                        _text("Email", const EdgeInsets.fromLTRB(0, 20, 0, 10)),
                        _textFieldEmail("learn@example.com", false),
                        _text("Password",
                            const EdgeInsets.fromLTRB(0, 20, 0, 10)),
                        _textFieldpass("use a strong password", true),
                        const SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            isSignup
                                ? Methods.instance
                                    .onSignup(_formKey, email, pass,name, context)
                                : Methods.instance
                                    .onLogin(_formKey, email, pass, context);
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text(
                              isSignup ? "Create Account" : "Login",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isSignup
                                  ? "Already have an account?"
                                  : "Don't have an account?",
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSignup = !isSignup;
                                });
                              },
                              child: Text(isSignup ? "  Login" : "  Sign Up",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _container(BuildContext context, IconData _iconData) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.43,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10, width: 3.0),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(_iconData),
        iconSize: 30,
        color: Colors.white,
      ),
    );
  }

  Widget _text(String data, EdgeInsets padding) {
    return Padding(
        padding: padding,
        child: Text(
          data,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ));
  }

  Widget _textFieldpass(String hintText, bool obscure) {
    return TextFormField(
      validator: (password) {
        if (password!.length < 6) {
          return "password must be greater than 6 characters";
        } else {
          return null;
        }
      },
      onChanged: (newPass) => pass = newPass,
      obscureText: _toggleVisiblity,
      cursorColor: Colors.purple,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: decoration(hintText, obscure),
    );
  }

  Widget _textFieldEmail(String hintText, bool obscure) {
    return TextFormField(
      validator: (email) {
        if (!email!.contains("@") || !email.contains(".")) {
          return "enter valid email";
        } else {
          return null;
        }
      },
      onChanged: (newEmail) => email = newEmail,
      cursorColor: Colors.purple,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: decoration(hintText, obscure),
    );
  }

  Widget _textFieldName(String hintText, bool obscure) {
    return TextFormField(
      validator: (name) {
        if (name!.isEmpty) {
          return "name cannot be empty";
        } else {
          return null;
        }
      },
      onChanged: (newName) => name = newName,
      cursorColor: Colors.purple,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      decoration: decoration(hintText, obscure),
    );
  }

  decoration(String hintText, bool obscure) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white60),
        enabledBorder: InputBorder(Colors.white60),
        focusedBorder: InputBorder(Colors.purpleAccent),
        errorBorder: InputBorder(Colors.red),
        suffixIcon: obscure
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _toggleVisiblity = !_toggleVisiblity;
                  });
                },
                icon: _toggleVisiblity
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility))
            : null);
  }

  OutlineInputBorder InputBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: color, style: BorderStyle.solid, width: 3.0));
  }

  _onFormSubmit() {
    if (_formKey.currentState!.validate()) {}
  }
}
