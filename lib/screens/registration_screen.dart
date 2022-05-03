import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:letschat/widgets/or_divider.dart';
import 'package:letschat/widgets/tabbutton_widget.dart';
import 'package:letschat/components/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letschat/widgets/social_icons.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscureText = true;
  bool showSpinner = false;
  String? name;
  late String email;
  late String password;
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();

  bool _validate = false;
  final _auth = FirebaseAuth.instance;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();
    _text3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.grey,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Créez un nouveau profil"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: nameInput(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: emailInput(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: passInput(),
              ),
              Padding(
                // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Hero(
                  tag: "button",
                  child: TabButton(
                    btnText: "Sign up",
                    btnTxtColor: Colors.white,
                    btnColor: PalletteColors.primaryRed,
                    btnFunction: () async {
                      (_text1.text.isEmpty ||
                              _text2.text.isEmpty ||
                              _text3.text.isEmpty)
                          ? _validate = true
                          : _validate = false;
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Déja enregistré ?",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: LoginScreen()));
                    },
                    child: Text(
                      " Se connecter",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: PalletteColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
              //////////////////social media feature
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 17),
              //   child: OrDivider(),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 25),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       SocialIcon(
              //         colors: [
              //           Color(0xFF102397),
              //           Color(0xFF187adf),
              //           Color(0xFF00eaf8),
              //         ],
              //         icon: Icon(FontAwesome.facebook, color: Colors.white),
              //         onPressed: () {},
              //       ),
              //       SocialIcon(
              //         colors: [
              //           Color(0xFFff4f38),
              //           Color(0xFFff355d),
              //         ],
              //         icon: Icon(FontAwesome.google, color: Colors.white),
              //         onPressed: () {},
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Theme(
      child: TextField(
        onChanged: (value) {
          email = value;
        },
        controller: _text2,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email ID",
          errorText: _validate ? 'Please Enter your Email ID' : null,
          prefixIcon: Icon(Icons.mail_outline),
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14),
        ),
        textInputAction: TextInputAction.next,
      ),
      data: Theme.of(context).copyWith(
        accentColor: PalletteColors.primaryRed,
      ),
    );
  }

  Widget nameInput() {
    return Theme(
      child: TextField(
        onChanged: (value) {
          name = value;
        },
        controller: _text1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Pseudonyme",
          errorText: _validate ? 'Veuillez entrer un pseudo' : null,
          prefixIcon: Icon(Icons.account_circle_rounded),
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14),
        ),
        textInputAction: TextInputAction.next,
      ),
      data: Theme.of(context).copyWith(
        accentColor: PalletteColors.primaryRed,
      ),
    );
  }

  Widget passInput() {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: PalletteColors.primaryRed,
      ),
      child: TextField(
        onChanged: (value) {
          password = value;
        },
        controller: _text3,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
          ),
          labelText: "Mot de passe",
          errorText:
              _validate ? 'Veuillez entrer un mot de passe valide' : null,
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: PalletteColors.primaryGrey,
            ),
            onPressed: _toggle,
          ),
        ),
        textInputAction: TextInputAction.done,
        obscureText: _obscureText,
      ),
    );
  }
}
